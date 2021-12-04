defmodule Day3BinaryDiagnostic do

  @type binary_list :: [0 | 1]

  @input_path Path.join(~w(assets input))

  def line_to_digits(line) do
    line
    |> String.trim()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end

  def stream_binary_digits_list(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&line_to_digits/1)
  end

  def extract_binary_lists(file_path) do
    file_path
    |> File.read!()
    |> String.split()
    |> Enum.map(&line_to_digits/1)
  end

  def most_common_bits(binary_lists) do
    binary_lists
    |> Enum.zip_with(&most_common_bit/1)
  end

  def ones_complement(binary_digits) do
    binary_digits
    |> Enum.map(&Bitwise.bxor(&1, 1))
  end

  def most_common_bit(items) do
    bit_count = Enum.frequencies(items)
    [ones, zeros] = [(bit_count[1] || 0), (bit_count[0] || 0)]
    if ones >= zeros, do: 1, else: 0
  end

  def find_oxygen_bit(binary_list), do: most_common_bit(binary_list)

  def find_co2_bit(binary_list) do
    bit_count = Enum.frequencies(binary_list)
    [ones, zeros] = [(bit_count[1] || 0), (bit_count[0] || 0)]
    cond do
      ones == 0 -> 0
      zeros == 0 -> 1
      zeros <= ones -> 0
      true -> 1
    end
  end

  def find_rating(binary_lists, bit_finder, rating \\ [])
  def find_rating([], _, rating), do: Enum.reverse rating
  def find_rating(binary_lists, bit_finder, rating) do
    rating_bit =
      binary_lists
      |> Stream.map(&hd/1)
      |> bit_finder.()

    reduced_lists =
      for [head | rest] <- binary_lists, head == rating_bit, length(rest) != 0, do: rest

    new_rating =
      [rating_bit | rating]

    find_rating(reduced_lists, bit_finder, new_rating)
  end

  def find_oxygen_rating(binary_lists), do: find_rating(binary_lists, &find_oxygen_bit/1)

  def find_co2_rating(binary_lists), do: find_rating(binary_lists, &find_co2_bit/1)

  def multiply_binary_lists(l1, l2) do
    [l1, l2]
    |> Enum.map(&Integer.undigits(&1, 2))
    |> Enum.product()
  end

  def solve_part_1(input_path \\ @input_path) do
    gamma_bits =
      input_path
      |> stream_binary_digits_list()
      |> most_common_bits()

    epilson_bits = ones_complement(gamma_bits)

    multiply_binary_lists(gamma_bits, epilson_bits)
  end

  def solve_part_2(input_path \\ @input_path) do
    binary_lists = extract_binary_lists(input_path)

    oxygen_rating = find_oxygen_rating(binary_lists)

    co2_rating = find_co2_rating(binary_lists)

    multiply_binary_lists(oxygen_rating, co2_rating)
  end
end

IO.puts Day3BinaryDiagnostic.solve_part_2()
