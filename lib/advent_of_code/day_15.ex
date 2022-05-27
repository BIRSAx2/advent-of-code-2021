defmodule AdventOfCode.Day15 do
  defp parse(input) do
    for {row, y} <- input |> String.split("\n", trim: true) |> Enum.with_index(),
        {elem, x} <- row |> String.split("", trim: true) |> Enum.with_index(),
        into: %{},
        do: {{x, y}, String.to_integer(elem)}
  end

  defp adjacent_positions(risk_level_grid, {x, y}) do
    Enum.map([{0, -1}, {-1, 0}, {0, 1}, {1, 0}], fn {a, b} -> {x + b, y + a} end)
    |> Enum.filter(&Map.has_key?(risk_level_grid, &1))
  end

  defp dijkstra_shortest_path(graph, start_vertex, end_vertex) do
    to_visit = :gb_sets.singleton({0, start_vertex})

    dijkstra(graph, end_vertex, to_visit, MapSet.new())
  end

  defp dijkstra(graph, destination, to_visit, visited) do
    {{distance, current_vertex}, to_visit} = :gb_sets.take_smallest(to_visit)

    if current_vertex == destination do
      distance
    else
      visited = MapSet.put(visited, current_vertex)

      to_visit =
        for neighbour <- adjacent_positions(graph, current_vertex),
            neighbour not in visited,
            new_cost = Map.get(graph, neighbour) + distance,
            reduce: to_visit do
          to_visit ->
            :gb_sets.add_element({new_cost, neighbour}, to_visit)
        end

      dijkstra(graph, destination, to_visit, visited)
    end
  end

  def part1(args) do
    risk_level_grid = parse(args)

    end_vertex = risk_level_grid |> Map.keys() |> Enum.sort() |> List.last()

    dijkstra_shortest_path(risk_level_grid, {0, 0}, end_vertex)
  end

  def part2(args) do
    risk_level_grid =
      parse(args)
      |> enlarge_grid()

    end_vertex = bottom_right_corner(risk_level_grid)

    dijkstra_shortest_path(risk_level_grid, {0, 0}, end_vertex)
  end

  defp enlarge_grid(grid) do
    {original_size_x, original_size_y} = bottom_right_corner(grid)

    # replicating the original grid to the right to form a row
    sample_row =
      Map.keys(grid)
      |> Enum.reduce(grid, fn {x, y}, grid ->
        old_value = Map.get(grid, {x, y})

        1..4
        |> Enum.reduce(grid, fn i, grid ->
          horizontal = {(original_size_x + 1) * i + x, y}

          new_value = rem(old_value + i, 9)
          new_value = if new_value == 0, do: 9, else: new_value

          Map.put(grid, horizontal, new_value)
        end)
      end)

    # replicating the sample_row downwards
    sample_row
    |> Map.keys()
    |> Enum.reduce(sample_row, fn {x, y}, sample_row ->
      old_value = Map.get(sample_row, {x, y})

      1..4
      |> Enum.reduce(sample_row, fn i, sample_row ->
        vertical = {x, (original_size_y + 1) * i + y}

        new_value = rem(old_value + i, 9)
        new_value = if new_value == 0, do: 9, else: new_value

        Map.put(sample_row, vertical, new_value)
      end)
    end)
  end

  defp bottom_right_corner(map) do
    max_x = map |> Enum.map(fn {{x, _y}, _} -> x end) |> Enum.max()
    max_y = map |> Enum.map(fn {{_x, y}, _} -> y end) |> Enum.max()
    {max_x, max_y}
  end
end
