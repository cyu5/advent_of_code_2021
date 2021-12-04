defmodule Day4GiantSquidTest do
  use ExUnit.Case
  doctest Day4GiantSquid
  import Day4GiantSquid

  @test_path "assets/test_input.txt"

  def do_test(fun, input, expected) do
    actual = fun.(input)
    assert actual == expected
  end

  describe "read data from file" do
    test "extract_nums/1" do
      str = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1"
      expected = [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1]
      do_test(&extract_nums/1, str, expected)
    end

    test "extract_row/1" do
      str = "22 13 17 11  0"
      expected = [22,13,17,11,0]
      do_test(&extract_row/1, str, expected)
    end

    test "extract_board" do
      str = "22 13 17 11  0\n      8  2 23  4 24\n     21  9 14 16  7\n      6 10  3 18  5\n      1 12 20 15 19"
      expected = [
        [22,13,17,11,0],
        [8,2, 23, 4, 24],
        [21 , 9, 14, 16 , 7],
        [6 ,10 , 3 ,18,  5],
        [1 ,12, 20 ,15 ,19]
      ]
      do_test(&extract_board/1, str, expected)
    end

    test "extract_board_set" do
      str = " 1 12 20 15 19\n\n3 15  0  2 22"
      expected = [
        [1,12,20,15,19],
        [3,15,0,2,22]
      ]
      actual = extract_board_set(str, &extract_row/1)
      assert actual == expected
    end

    test "extract_input" do
      str = "7,26,0\n\n22 13\n17 11\n\n21  9\n16  7"
      expected = {
        [7,26,0],
        [
          [
            [22,13],
            [17,11]
          ],
          [
            [21,9],
            [16,7]
          ]
        ]
      }
      do_test(&extract_input/1, str, expected)
    end

    test "read_input_data" do
      actual = read_input_data("assets/test_extract.txt")
      expected = {[1,2,3], [
        [
          [4,5],
          [6,7]
        ],
        [
          [8.9],
          [10,11]
        ]
      ]}
      assert actual == expected
    end
  end

  describe "simulate bingo" do
    test "get info/1" do

    end
  end

end
