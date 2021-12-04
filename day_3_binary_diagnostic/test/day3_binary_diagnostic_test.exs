defmodule Day3BinaryDiagnosticTest do
  use ExUnit.Case, async: false
  doctest Day3BinaryDiagnostic
  import Day3BinaryDiagnostic

  @test_path Path.join(~w(assets test_input))
  @test_output_part_1 198
  @test_output_part_2 230

  describe "line_to_digits/1" do
    test "return correct output" do
      assert line_to_digits("11010\n") == [1, 1, 0, 1, 0]
    end
  end

  describe "most_common_bit/1" do
    test "return 1 when 1 is most common" do
      input = [1,1,1,0,0]
      assert most_common_bit(input) == 1
    end
    test "return 1 when 1 and 0 are equally common" do
      input = [1,0,1,1,0,1,0,0]
      assert most_common_bit(input) == 1
    end
    test "return 0 when 0 is most common" do
      input = [1,0,1,1,0,1,0,0,0]
      assert most_common_bit(input) == 0
    end
  end

  describe "most_common_bits/1" do
    test "return correct output" do
      binary_digits_list = [
        [1, 0, 1, 1, 0],
        [1, 0, 1, 1, 1],
        [0, 0, 0, 1, 1]
      ]
      expected = [1, 0, 1, 1, 1]
      assert most_common_bits(binary_digits_list) == expected
    end
  end

  describe "ones_complement/1" do
    test "return correct output" do
      assert ones_complement([1,0,1,1,0]) == [0, 1, 0, 0, 1]
    end
  end

  describe "find_oxygen_rating" do
    test "return correct output" do
      binary_lists = extract_binary_lists(@test_path)
      assert find_oxygen_rating(binary_lists) == [1, 0, 1, 1, 1]
    end
  end

  describe "find_co2_rating" do
    test "return correct output" do
      binary_lists = extract_binary_lists(@test_path)
      assert find_co2_rating(binary_lists) == [0,1,0,1,0]
    end

  end

  describe "solve_part_1" do
    test "test input" do
      assert solve_part_1(@test_path) == @test_output_part_1
    end
  end

  describe "solve_part_2" do
    test "test input" do
      assert solve_part_2(@test_path) == @test_output_part_2
    end
  end

end
