defmodule AdventOfCode.Day06 do
  def parse(args) do
    args
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(args) do
    solve(args, 80)
  end

  defp solve(args, days) do
    amounts =
      args
      |> parse()
      |> Enum.frequencies()
      |> then(
        &(Enum.map(0..8, fn day -> &1[day] || 0 end)
          |> List.to_tuple())
      )

    0..(days - 1)
    |> Enum.reduce(amounts, fn _, {day0, day1, day2, day3, day4, day5, day6, day7, day8} ->
      {day1, day2, day3, day4, day5, day6, day7 + day0, day8, day0}
    end)
    |> Tuple.sum()
  end

  def part2(args) do
    solve(args, 256)
  end
end
