defmodule Day1SonarSweep do

  @input_file_path Path.join(["assets", "input.txt"])

  def increase_count(num_stream) do
    num_stream
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [prev, curr] -> (if prev < curr, do: 1, else: 0) end)
    |> Enum.sum()
  end

  def stream_data_from_input_file(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def solve_part_1(input_file_path \\ @input_file_path) do
    input_file_path
    |> stream_data_from_input_file()
    |> increase_count()
  end

  def stream_three_sized_window_sum(num_stream) do
    num_stream
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(&Enum.sum/1)
  end
  def solve_part_2(input_file_path \\ @input_file_path) do
    input_file_path
    |> stream_data_from_input_file()
    |> stream_three_sized_window_sum()
    |> increase_count()
  end
end
