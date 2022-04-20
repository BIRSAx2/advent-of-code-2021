defmodule AdventOfCode.Day07 do
  defp parse(args) do
    args
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(args) do
    input = args |> parse()

    input
    |> Enum.map(fn val ->
      input
      |> Enum.map(fn crab ->
        abs(crab - val)
      end)
      |> Enum.sum()
    end)
    |> List.flatten()
    |> Enum.min()
  end

  def part2(args) do
    input = parse(args)

    avg = Enum.sum(input) / length(input)

    {low, high} =
      input
      |> Enum.reduce({0, 0}, fn crab, {current_low, current_high} ->
        low = abs(floor(avg) - crab)
        high = abs(round(avg) - crab)

        {current_low + low * (low + 1) / 2, current_high + high * (high + 1) / 2}
      end)

    min(low, high) |> round()
  end
end
