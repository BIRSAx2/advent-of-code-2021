defmodule AdventOfCode.Day12 do
  defp parse(args) do
    caves = Map.new()

    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.reduce(caves, fn [origin, destination], caves ->
      caves
      |> Map.update(origin, [destination], fn edges ->
        [destination | edges]
      end)
      |> Map.update(destination, [origin], fn edges ->
        [origin | edges]
      end)
    end)
  end

  def part1(args) do
    args
    |> parse()
    |> depth_first_traversal(&(upcase?(&1) or &1 not in &2))
  end

  defp depth_first_traversal(adj_list, visitable?, origin \\ "start", destination \\ "end", visited \\ [], path \\ [], count \\ 0)

  defp depth_first_traversal(adj_list, visitable?, origin, destination, visited, path, count) do
    visited = [origin | visited]
    path = path ++ [origin]

    cond do
      origin == destination ->
        count + 1

      true ->
        Map.get(adj_list, origin)
        |> Enum.reduce(count, fn cave, count ->
          if visitable?.(cave, visited) do
            depth_first_traversal(adj_list, visitable?, cave, destination, visited, path, count)
          else
            count
          end
        end)
    end
  end

  defp upcase?(str) do
    str == String.upcase(str)
  end

  def part2(args) do
    adjacency_list = parse(args)

    max_small_cave = fn visited ->
      visited
      |> Enum.filter(&(not upcase?(&1) and &1 not in ["start", "end"]))
      |> Enum.frequencies()
      |> Enum.max_by(fn {_, v} -> v end)
      |> then(fn {_, v} -> v end)
    end

    visitable? = fn cave, visited ->
      cond do
        upcase?(cave) or cave not in visited ->
          true

        cave in ["start", "end"] ->
          false

        cave in visited and max_small_cave.(visited) < 2 ->
          true

        true ->
          false
      end
    end

    depth_first_traversal(adjacency_list, visitable?)
  end
end
