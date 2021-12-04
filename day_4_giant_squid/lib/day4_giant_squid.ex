defmodule Day4GiantSquid do
  @type numbers :: [Integer]
  @type row :: [Integer]
  @type board :: [row]
  @type board_set :: [board]
  @type point :: {Integer, Integer}

  @input_path "assets/input.txt"

  @spec trim_split_map(binary, (String.t -> any), binary) :: list
  defp trim_split_map(str, fun \\ &String.to_integer/1, pattern \\ " ") do
    str
    |> String.trim()
    |> String.split(pattern, trim: true)
    |> Enum.map(fun)
  end

  @spec extract_nums(binary) :: numbers
  def extract_nums(str) do
    trim_split_map(str, &String.to_integer/1, ",")
  end

  @spec extract_row(binary) :: row
  def extract_row(str) do
    trim_split_map(str)
  end

  @spec extract_board(binary) :: board
  def extract_board(str) do
    trim_split_map(str, &extract_row/1, "\n")
  end

  @spec extract_board_set(binary, (binary -> any)) :: board_set
  def extract_board_set(str, extractor \\ &extract_board/1) do
    trim_split_map(str, extractor, "\n\n")
  end

  @spec extract_input(binary) :: {numbers, board_set}
  def extract_input(str) do
    [nums_str, board_set_str] = String.split(str, "\n\n", parts: 2)
    {extract_nums(nums_str),  extract_board_set(board_set_str)}
  end

  @spec read_input_data(binary) :: {numbers, board_set}
  def read_input_data(path \\ @input_path) do
    path
    |> File.read!()
    |> extract_input()
  end

  defp board_map(board) do
    for {row, i} <- Enum.with_index(board),
          {num, j} <- Enum.with_index(row),
          into: %{},
          do: {num, {i, j}}
  end

  defp row_sums(board) do
    Enum.map(board, &Enum.sum/1)
  end

  defp col_sums(board) do
    Enum.zip_with(board, &Enum.sum/1)
  end

  @spec get_info(board) :: {%{Integer => point}, [Integer], [Integer]}
  def get_info(board) do
    {board_map(board), row_sums(board), col_sums(board)}
  end

  @spec bingo_result(board, numbers) :: {Integer, Integer}
  def bingo_result(board, nums) do
    {map, rows, cols} = get_info(board)
    do_bingo_result(map, rows, cols, nums)
  end

  @spec wins?([Integer], [Integer]) :: boolean
  def wins?(rows, cols) do
    Enum.any?(rows++cols, &(&1==0))
  end

  def update_bingo_state(map, rows, cols, num, steps) do
    updated_steps = steps + 1
    {updated_rows, updated_cols} =
      if map[num] do
        {row, col} = map[num]
        {List.update_at(rows, row, & &1-num),
        List.update_at(cols, col, & &1-num)}
      else
        {rows,
        cols}
      end
    {updated_rows, updated_cols, updated_steps}
  end

  @spec get_score([Integer], [Integer], Integer) :: Integer
  def get_score(rows, cols, num) do
    if wins?(rows, cols), do: Enum.sum(rows) * num, else: 0
  end

  @spec do_bingo_result(any, any, any, maybe_improper_list, number) :: {Integer, Integer}
  def do_bingo_result(map, rows, cols, nums, steps \\ 0)
  def do_bingo_result(_, _, _, [], steps), do: {steps+1, 0}
  def do_bingo_result(map, rows, cols, [num | nums], steps) do
    {updated_rows, updated_cols, updated_steps} =
      update_bingo_state(map, rows, cols, num, steps)
    if wins?(updated_rows, updated_cols) do
      {updated_steps, get_score(updated_rows, updated_cols, num)}
    else
      do_bingo_result(map, updated_rows, updated_cols, nums, updated_steps)
    end
  end

  @spec get_winning_score(board_set, numbers) :: Integer
  def get_winning_score(board_set, nums) do
    {_steps, score} =
      board_set
      |> Stream.map(&bingo_result(&1, nums))
      |> Enum.min_by(fn {steps, _score} -> steps end)
    score
  end

  @spec get_losing_score(board_set, numbers) :: Integer
  def get_losing_score(board_set, nums) do
    {_steps, score} =
      board_set
      |> Stream.map(&bingo_result(&1, nums))
      |> Enum.max_by(fn {steps, _score} -> steps end)
    score
  end

  @spec solve_part_1(binary) :: Integer
  def solve_part_1(path \\ @input_path) do
    {nums, board_set} = read_input_data path
    get_winning_score(board_set, nums)
  end

  @spec solve_part_2(binary) :: Integer
  def solve_part_2(path \\ @input_path) do
    {nums, board_set} = read_input_data path
    get_losing_score(board_set, nums)
  end

end

Day4GiantSquid.solve_part_1()
# TODOS
# 1. learning debugging tools build-in elixir
# 2. learn iex commands
# 3. learn regex and text editing for sublime
# 4. learn how to import large variable directly
