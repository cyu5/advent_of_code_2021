defmodule Day2DiveTest do
  use ExUnit.Case, async: false
  doctest Day2Dive
  import Day2Dive

  @test_input_file_path Path.join(~w(assets test_input.txt))
  @test_part_1_answer 150
  @test_part_2_answer 900

  describe "solve_part_1/1" do
    test "return correctly for test input file" do
      assert solve_part_1(@test_input_file_path) == @test_part_1_answer
    end
  end

  describe "solve_part_2/1" do
    test "return correctly for test input file" do
      assert solve_part_2(@test_input_file_path) == @test_part_2_answer
    end
  end
end
