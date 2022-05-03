defmodule AdventOfCode.Day13 do
  defp parse(args) do
    [paper, instructions] = String.split(args, "\n\n", trim: true)

    paper =
      paper
      |> String.split("\n", trim: true)
      |> Enum.map(fn point ->
        String.split(point, ",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.into(MapSet.new())

    instructions =
      instructions
      |> String.split("\n", trim: true)
      |> Enum.map(fn instruction ->
        Regex.run(~r/[x|y]=\d+/, instruction)
        |> Enum.map(fn point ->
          [axis, line] = String.split(point, "=")
          {String.to_atom(axis), String.to_integer(line)}
        end)
      end)
      |> List.flatten()

    {paper, instructions}
  end

  def part1(args) do
    {paper, [instruction | _]} = parse(args)

    fold(paper, [instruction]) |> MapSet.size()
  end

  def part2(args) do
    {paper, instructions} = parse(args)

    fold(paper, instructions) |> paper_to_string() |> IO.puts()
  end

  defp paper_to_string(paper) do
    [_, max_y] = Enum.max_by(paper, fn [_, y] -> y end)
    [max_x, _] = Enum.max_by(paper, fn [x, _] -> x end)

    for y <- 0..max_y do
      # line
      for x <- 0..max_x do
        if MapSet.member?(paper, [x, y]), do: "#", else: " "
      end ++ ["\n"]
    end
    |> Enum.join()
  end

  defp fold(paper, instructions) do
    instructions
    |> Enum.reduce(paper, fn {axis, line}, to_fold ->
      Enum.reduce(to_fold, to_fold, fn [x, y], folded_paper ->
        cond do
          axis == :x and x >= line ->
            MapSet.delete(folded_paper, [x, y]) |> MapSet.put([2 * line - x, y])

          axis == :y and y >= line ->
            MapSet.delete(folded_paper, [x, y]) |> MapSet.put([x, 2 * line - y])

          true ->
            folded_paper
        end
      end)
    end)
  end
end
