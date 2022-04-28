defmodule AdventOfCode.Day09 do
  @offsets [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

  def parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> then(fn rows ->
      for {line, row} <- Enum.with_index(rows),
          {number, col} <- Enum.with_index(line),
          into: %{} do
        {{row, col}, number}
      end
    end)
  end

  defp low_points(heightmap) do
    heightmap
    |> Enum.filter(fn {_, value} = point ->
      neighbours =
        neighbours(heightmap, point)
        |> Enum.map(fn {_, value} -> value end)
        |> Enum.filter(&(&1 <= value))

      length(neighbours) == 0
    end)
  end

  defp neighbours(heightmap, {{x, y}, _}) do
    @offsets
    |> Enum.map(fn {offset_x, offset_y} ->
      # making 9 the default value to avoid handling edge cases
      value = Map.get(heightmap, {x + offset_x, y + offset_y}, 9)
      {{x + offset_x, y + offset_y}, value}
    end)
  end

  def part1(args) do
    args
    |> parse()
    |> low_points()
    |> Enum.map(fn {_, value} -> value end)
    |> Enum.reduce(0, fn value, acc -> acc + value + 1 end)
  end

  def part2(args) do
    heightmap = parse(args)

    heightmap
    |> low_points()
    |> Enum.map(fn low_point ->
      find_basin(heightmap, [low_point])
      |> then(&length/1)
    end)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.reduce(&(&1 * &2))
  end

  def find_basin(heightmap, stack, visited \\ [])
  def find_basin(_heightmap, [], visited), do: visited

  def find_basin(heightmap, [head | rest], visited) do
    points =
      neighbours(heightmap, head)
      |> Enum.filter(fn {_, value} -> value != 9 end)
      |> Enum.filter(&(&1 not in visited))

    find_basin(heightmap, rest ++ points, visited ++ points)
  end
end
