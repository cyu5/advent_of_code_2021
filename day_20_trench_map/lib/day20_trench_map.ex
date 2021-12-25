defmodule Day20TrenchMap do

  @input File.read!("./assets/input.txt")

  def get_example do
    "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###"
  end

  def parse(input) do
    [algo_str, image] = String.split(input, "\n\n", trim: true)
    algo =
      algo_str
      |> String.codepoints
      |> Stream.with_index
      |> Stream.map(fn
        {"#", i} -> {i, 1}
        {".", i} -> {i, 0}
      end)
      |> Enum.into(%{})

    rows = String.split(image, "\n", trim: true)
    n = length(rows)
    m = rows |> hd |> byte_size
    image_bounds = {{0, 0}, {n, m}}

    image_map =
      for {row, i} <- rows |> Stream.with_index,
          {pixel, j} <- row |> String.codepoints |> Stream.with_index,
          into: %{} do
        case pixel do
          "#" -> {{i, j}, 1}
          "." -> {{i, j}, 0}
        end
      end
    {algo, image_map, image_bounds}
  end

  def enhance_pixel({x, y}, image, algo, background) do
    for nx <- [x-1, x, x+1],
        ny <- [y-1, y, y+1] do
      Map.get(image, {nx, ny}, background)
    end
    |> Integer.undigits(2)
    |> then(fn bin -> algo[bin] end)

    # Map.get(image, {x, y}, background)
  end

  def enhance({image, bounds, background}, algo) do
    # {top_left, bottom_right} = bounds
    {{tx, ty}, {bx, by}} = bounds
    new_bounds = {{tx-1, ty-1}, {bx+1, by+1}}

    new_image =
      for x <- (tx-1)..(bx+1),
          y <- (ty-1)..(by+1),
          into: %{} do
        new_pixel = enhance_pixel({x, y}, image, algo, background)
        {{x, y}, new_pixel}
      end

    new_background = if background == 1, do: algo[0b111_111_111], else: algo[0]

    {new_image, new_bounds, new_background}
  end

  def solve_part_1(input \\ @input) do
    {algo, image, bounds} = parse(input)

    {final_image, final_bounds, final_background} =
      {image, bounds, 0}
      |> Stream.iterate(&enhance(&1, algo))
      |> Enum.at(2)

    final_image
    |> Map.values
    |> Enum.sum

    # {final_bounds, final_background}
  end

  def solve_part_2(input \\ @input) do
    {algo, image, bounds} = parse(input)

    {final_image, final_bounds, final_background} =
      {image, bounds, 0}
      |> Stream.iterate(&enhance(&1, algo))
      |> Enum.at(50)

    final_image
    |> Map.values
    |> Enum.sum
  end
end

Day20TrenchMap.get_example()
Day20TrenchMap.solve_part_2()
|> IO.inspect()
