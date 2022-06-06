defmodule AdventOfCode.Day17 do
  defp parse(args) do
    regex =
      ~r/target area: x=(?<start_x>-?\d+)\.\.(?<end_x>-?\d+), y=(?<start_y>-?\d+)\.\.(?<end_y>-?\d+)/

    [end_x, end_y, start_x, start_y] =
      regex
      |> Regex.named_captures(args)
      |> Enum.map(fn {_, v} -> String.to_integer(v) end)

    {start_x, end_x, start_y, end_y}
  end

  def part1(args) do
    {_, _, start_y, _} = parse(args)

    div(start_y * (start_y + 1), 2)
  end

  defp brute_force({start_x, end_x, start_y, end_y} = target) do
    0..abs(end_x)
    |> Enum.map(fn x ->
      -abs(start_y)..abs(start_y)
      |> Enum.map(fn y ->
        {{x, y}, launch_probe({x, y}, target)}
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> length()
  end

  defp launch_probe(velocity, target, initial_position \\ {0, 0}, max_heigth \\ 0)

  defp launch_probe({vel_x, vel_y}, target, {x, y} = current_position, max_heigth) do
    cond do
      reached_target(current_position, target) ->
        max_heigth

      overshoot(current_position, target) ->
        nil

      true ->
        current_position = {x + vel_x, y + vel_y}

        velocity =
          cond do
            vel_x > 0 -> {vel_x - 1, vel_y - 1}
            vel_x < 0 -> {vel_x + 1, vel_y - 1}
            vel_x = 0 -> {vel_x, vel_y - 1}
          end

        launch_probe(velocity, target, current_position, max(max_heigth, y + vel_y))
    end
  end

  defp reached_target({x, y}, {start_x, end_x, start_y, end_y}) do
    x in start_x..end_x and y in start_y..end_y
  end

  defp overshoot({x, y}, {_start_x, end_x, start_y, end_y}) do
    x > end_x || y < min(start_y, end_y)
  end

  def part2(args) do
    target = parse(args)
    brute_force(target)
  end
end
