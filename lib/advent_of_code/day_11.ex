defmodule AdventOfCode.Day11 do
  def parse(args) do
    args
    |> String.split("\n", trim: true)
    |> then(fn lines ->
      for {line, row} <- Enum.with_index(lines),
          {energy, col} <- Enum.with_index(String.to_charlist(line)),
          into: %{},
          do: {{row, col}, energy - ?0}
    end)
  end

  defp adjacent_octopuses(octopuses, {x, y}) do
    for offset_x <- [-1, 0, 1],
        offset_y <- [-1, 0, 1],
        {offset_x, offset_y} != {0, 0} and {x + offset_x, y + offset_y} in Map.keys(octopuses) do
      {x + offset_x, y + offset_y}
    end
  end

  def part1(args) do
    octopuses = parse(args)

    1..100
    |> Enum.map_reduce(octopuses, fn _, octopuses ->
      {octopuses, flashes} = flash(Map.keys(octopuses), octopuses, MapSet.new())
      {flashes, octopuses}
    end)
    |> elem(0)
    |> Enum.sum()
  end

  defp flash([], grid, flashed) do
    {grid, MapSet.size(flashed)}
  end

  defp flash([key | keys], octopuses, flashed) do
    energy = Map.get(octopuses, key)

    cond do
      key in flashed ->
        flash(keys, octopuses, flashed)

      energy >= 9 ->
        to_flash = adjacent_octopuses(octopuses, key) ++ keys
        flash(to_flash, Map.put(octopuses, key, 0), MapSet.put(flashed, key))

      true ->
        flash(keys, Map.put(octopuses, key, energy + 1), flashed)
    end
  end

  def part2(args) do
    octopuses = parse(args)

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(octopuses, fn i, octopuses ->
      case flash(Map.keys(octopuses), octopuses, MapSet.new()) do
        {octopuses, flashed} when map_size(octopuses) == flashed -> {:halt, i}
        {octopuses, _} -> {:cont, octopuses}
      end
    end)
  end
end
