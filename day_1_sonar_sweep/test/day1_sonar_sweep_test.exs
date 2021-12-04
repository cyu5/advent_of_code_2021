defmodule Day1SonarSweepTest do

  # run test synchronously to be able to use the same file path for all tests without write conflicts
  use ExUnit.Case, async: false
  doctest Day1SonarSweep
  import Day1SonarSweep

  @test_file_data [199,
  200,
  208,
  210,
  200,
  207,
  240,
  269,
  260,
  263]
  @test_data_sliding_window_sum [607,
  618,
  618,
  617,
  647,
  716,
  769,
  792]
  @test_file_data_output 7
  @test_file_data_output_part_2 5
  @test_file_path ["assets", "test_input.txt"] |> Path.join()

  describe "increase_count/1" do
    test "return 0 when given empty list" do
      assert increase_count([]) == 0
    end

    test "return 0 when given list with one item" do
      assert increase_count([1]) == 0
      assert increase_count([0]) == 0
    end

    test "return 0 for decreasing list" do
      depths = [3,2,1,1,0]
      assert increase_count(depths) == 0
    end

    test "return length-1 for increasing list" do
      depths = [1,2,3]
      assert increase_count(depths) == length(depths) - 1
    end

    test "return 0 for list with all equal nums" do
      depths = [4,4,4,4,4]
      assert increase_count(depths) == 0
    end

    test "is correct for example input from problem statement" do
      depths = [199,
      200,
      208,
      210,
      200,
      207,
      240,
      269,
      260,
      263]
      assert increase_count(depths) == 7
    end

    test "random tests" do
      testpoints = [
        [[1,4,7,9,342,7,89,9,3,3,0], 5],
        [[4564,894,131,654,848,651,3215,46,84,6,8], 5],
        [[546646,87978,1569,44453,16464,544,6456464513,88,51,3,555], 3],
        [[0,1,2,1,0,1,2,0,2,3,4,4,4,5,1,2,3,4,56,0], 12]
      ]
      testpoints
      |> Enum.each(fn [depths, output] -> assert increase_count(depths) == output end)
    end

  end

  describe "stream_data_from_input_file/1" do
    test "correctly streams file" do
      @test_file_path
      |> stream_data_from_input_file()
      |> Stream.zip(@test_file_data)
      |> Stream.each(fn {a, b} -> assert a==b end)
      |> Stream.run()
    end
  end

  describe "solve_part_1/1" do
    test "correctly solve part 1 with test file" do
      actual = solve_part_1(@test_file_path)
      assert actual == @test_file_data_output
    end
  end

  describe "stream_three_sized_window_sum/1" do
    test "doesn't stream if input is empty list" do
      actual =
        []
        |> stream_three_sized_window_sum()
        |> Enum.to_list()
      assert actual == []
    end

    test "doesn't stream if input list is less than 3" do
      actual =
        [1, 2]
        |> stream_three_sized_window_sum()
        |> Enum.to_list()
      assert actual == []
    end

    test "streams 1 element if input list is 3" do
      actual =
        [1, 1, 1]
        |> stream_three_sized_window_sum()
        |> Enum.to_list()
      assert actual == [3]
    end

    test "return correct output for more than 3 elements" do
      actual =
        [1, 1, 1, 1]
        |> stream_three_sized_window_sum()
        |> Enum.to_list()
      assert actual == [3, 3]

      actual =
        [1, 2, 1, 4, 6, 0]
        |> stream_three_sized_window_sum()
        |> Enum.to_list()
      assert actual == [4, 7, 11, 10]
    end

    test "return correct output for example input from problem statement" do
      actual =
        @test_file_data
        |> stream_three_sized_window_sum()
        |> Enum.to_list()
      assert actual == @test_data_sliding_window_sum
    end
  end

  describe "solve_part_2/1" do
    test "correctly solves for example input from problem statement" do
      assert solve_part_2(@test_file_path) == @test_file_data_output_part_2
    end
  end

end
