defmodule AdventOfCode.Day20 do
  import Bitwise

  defp parse(args) do
    [algorithm | image] =
      args
      |> String.split(["\n\n", "\n"], trim: true)
      |> Enum.map(fn el ->
        el
        |> String.split("", trim: true)
        |> Enum.map(fn
          "." -> 0
          "#" -> 1
        end)
      end)

    image =
      for {line, row} <- Enum.with_index(image),
          {number, col} <- Enum.with_index(line),
          into: %{} do
        {{row, col}, number}
      end

    algorithm =
      for {k, v} <- Enum.with_index(algorithm), into: %{} do
        {v, k}
      end

    {algorithm, image}
  end

  defp neighbours({x, y}) do
    for row_offset <- -1..1, col_offset <- -1..1 do
      {x + row_offset, y + col_offset}
    end
  end

  defp enhance(image, algorithm, count, new_image) do
    field = count - 1 &&& algorithm[0]

    {{min_row, min_col}, {max_row, max_col}} = Map.keys(image) |> Enum.min_max()

    for row <- (min_row - 2)..(max_row + 2),
        col <- (min_col - 2)..(max_col + 2),
        into: new_image do
      {row, col}
      |> neighbours()
      |> Enum.map(&Map.get(image, &1, field))
      |> Integer.undigits(2)
      |> then(fn i -> {{row, col}, algorithm[i]} end)
    end
  end

  def part1(args) do
    {algorithm, image} = parse(args)

    Enum.reduce(1..2, image, fn count, image ->
      enhance(image, algorithm, count, %{})
    end)
    |> Enum.count(fn {_, v} -> v == 1 end)
  end

  def part2(args) do
    {algorithm, image} = parse(args)

    Enum.reduce(1..50, image, fn count, image ->
      enhance(image, algorithm, count, %{})
    end)
    |> Enum.count(fn {_, v} -> v == 1 end)
  end
end
