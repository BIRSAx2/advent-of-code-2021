defmodule AdventOfCode.Day04 do
  import Bitwise

  def parse(args) do
    [numbers | boards] =
      args
      |> String.split("\n", trim: true)

    numbers =
      numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    empty_board = 0
    board = %{numbers: %{}, board: empty_board, win: false}

    boards =
      boards
      |> Enum.chunk_every(5)
      |> Enum.map(fn rows ->
        for {line, row} <- Enum.with_index(rows),
            {number, col} <- Enum.with_index(String.split(line)),
            into: %{} do
          {String.to_integer(number), {row, col}}
        end
      end)
      |> Enum.map(fn numbers ->
        board |> Map.update!(:numbers, fn _ -> numbers end)
      end)

    {numbers, boards}
  end

  def part1(args) do
    {numbers, cards} = parse(args)
    {last_number_called, card} = find_winner(numbers, cards)

    calculate_score(card, last_number_called)
  end

  defp calculate_score(card, number) do
    sum =
      card[:numbers]
      |> Enum.reduce(0, fn {n, {row, col}}, acc ->
        pos = row * 5 + col
        mask = 1 <<< (5 * 5 - pos)

        if band(card[:board], mask) != mask do
          acc + n
        else
          acc
        end
      end)

    sum * number
  end

  defp find_winner(numbers, cards, last \\ false)

  defp find_winner([number | numbers], cards, last) do
    cards =
      cards
      |> Enum.map(fn card ->
        marked = mark_number(number, card)
        won = won?(marked)
        Map.update!(marked, :win, fn _ -> won end)
      end)

    cards =
      if last && length(cards) > 1,
        do: Enum.filter(cards, fn card -> card[:win] == false end),
        else: cards

    winners = cards |> Enum.filter(fn card -> card[:win] == true end)

    if winners != [] do
      {number, hd(winners)}
    else
      find_winner(numbers, cards, last)
    end
  end

  defp mark_number(number, card) do
    board =
      if Map.has_key?(card[:numbers], number) do
        {row, col} = card[:numbers][number]
        # bit mask
        pos = row * 5 + col
        mask = 1 <<< (5 * 5 - pos)
        bor(card[:board], mask)
      else
        card[:board]
      end

    Map.update!(card, :board, fn _ -> board end)
  end

  defp won?(board) do
    winning_rows = [
      0b11111_0,
      0b11111_00000_0,
      0b11111_00000_00000_0,
      0b11111_00000_00000_00000_0,
      0b11111_00000_00000_00000_00000_0
    ]

    winning_cols = [
      0b10000_10000_10000_10000_10000,
      0b01000_01000_01000_01000_01000_0,
      0b00100_00100_00100_00100_00100_0,
      0b00010_00010_00010_00010_00010_0,
      0b00001_00001_00001_00001_00001_0
    ]

    won_row = true in Enum.map(winning_rows, fn row -> band(row, board[:board]) == row end)
    won_col = true in Enum.map(winning_cols, fn col -> band(col, board[:board]) == col end)

    won_row || won_col
  end

  def part2(args) do
    {numbers, cards} = parse(args)
    {last_number_called, card} = find_winner(numbers, cards, true)

    calculate_score(card, last_number_called)
  end
end
