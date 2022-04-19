defmodule AdventOfCode.Day05 do
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ", trim: true)
      |> Enum.map(fn point ->
        point
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    end)
  end

  def part1(args) do
    parse(args)
    |> find_horitontal_vertical_lines()
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.count(fn {_, n} -> n >= 2 end)
  end

  def part2(args) do
    grid = %{}

    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([",", " -> "], trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce(grid, fn
      [x, y1, x, y2], grid ->
        Enum.reduce(y1..y2, grid, fn y, grid ->
          Map.update(grid, {x, y}, 1, &(&1 + 1))
        end)

      [x1, y, x2, y], grid ->
        Enum.reduce(x1..x2, grid, fn x, grid ->
          Map.update(grid, {x, y}, 1, &(&1 + 1))
        end)

      [x1, y1, x2, y2], grid ->
        Enum.reduce(Enum.zip(x1..x2, y1..y2), grid, fn {x, y}, grid ->
          Map.update(grid, {x, y}, 1, &(&1 + 1))
        end)
    end)
    |> Enum.count(fn {_k, v} -> v > 1 end)
  end

  defp find_horitontal_vertical_lines(input) do
    input
    |> Enum.filter(fn [[x1, y1], [x2, y2]] ->
      x1 == x2 || y1 == y2
    end)
    |> Enum.map(fn [[x1, y1], [x2, y2]] ->
      for x <- x1..x2, y <- y1..y2 do
        {x, y}
      end
    end)
    |> List.flatten()
  end
end
