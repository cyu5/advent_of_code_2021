defmodule Day2Dive do
  @type vector :: {integer, integer}
  @input_file_path Path.join(~w(assets input.txt))

  @spec to_vector([binary, ...]) :: vector
  def to_vector(["forward", mag]), do: {String.to_integer(mag), 0}
  def to_vector(["down", mag]), do: {0, String.to_integer(mag)}
  def to_vector(["up", mag]), do: {0, -String.to_integer(mag)}

  @spec add_vectors(vector, vector) :: vector
  def add_vectors({v1, u1}, {v2, u2}) do
    {v1+v2, u1+u2}
  end

  def update_pos_with_aim([dir, mag], {x, y, a}) do
    m = String.to_integer(mag)
    case dir do
      "forward" -> {x+m, y+m*a, a}
      "down" -> {x, y, a+m}
      "up" -> {x, y, a-m}
      _ -> {x, y, a}
    end
  end

  def solve_part_1(input_file_path \\ @input_file_path) do
    {x, y} =
      input_file_path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split/1)
      |> Stream.map(&to_vector/1)
      |> Enum.reduce(&add_vectors/2)
    x * y
  end

  def solve_part_2(input_file_path \\ @input_file_path) do
    {x, y, _} =
      input_file_path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split/1)
      |> Enum.reduce({0, 0, 0}, &update_pos_with_aim/2)
    x * y
  end
end
