defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> format_input()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a, b] -> b > a end)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> format_input()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a, b] -> b > a end)
    |> Enum.count()
  end

  defp format_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn measurment ->
      {num, _} = Integer.parse(measurment)
      num
    end)
  end
end
