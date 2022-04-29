defmodule AdventOfCode.Day10 do
  @opening_braces %{"(" => ")", "<" => ">", "[" => "]", "{" => "}"}
  @closing_braces %{")" => "(", ">" => "<", "]" => "[", "}" => "{"}

  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def part1(args) do
    points = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

    args
    |> parse()
    |> Enum.map(&recur(&1))
    |> Enum.filter(&(not is_list(&1)))
    |> Enum.frequencies()
    |> Enum.map(fn {brace, count} ->
      count * Map.get(points, brace)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    points = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

    scores =
      args
      |> parse()
      |> Enum.map(&recur(&1))
      |> Enum.filter(&is_list/1)
      |> Enum.map(
        &Enum.reduce(&1, 0, fn brace, total ->
          total * 5 + Map.get(points, brace)
        end)
      )
      |> Enum.sort()

    middle_index = length(scores) |> div(2)
    Enum.at(scores, middle_index)
  end

  # recur returns the first incorrect closing brace, if the line is corrupt, or a list of closing braces when the line is incomplete
  defp recur(line, open \\ [], close \\ [])

  defp recur(_line, _open, brace) when not is_list(brace), do: brace

  defp recur([], _open, close), do: close

  defp recur(line, open, close) do
    [brace | remaining_line] = line

    if brace in Map.keys(@opening_braces) do
      close = [Map.get(@opening_braces, brace) | close]
      open = [brace | open]

      recur(remaining_line, open, close)
    else
      [last | rest] = open

      if Map.get(@closing_braces, brace) == last do
        recur(remaining_line, rest, tl(close))
      else
        recur(remaining_line, rest, brace)
      end
    end
  end
end
