defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> format_input()
    |> Enum.reduce([0, 0], fn {direction, value}, [position, depth] ->
      val = String.to_integer(value)

      [
        position +
          case direction do
            "forward" -> val
            _ -> 0
          end,
        depth +
          case direction do
            "down" -> val
            "up" -> -val
            _ -> 0
          end
      ]
    end)
    |> then(fn [position, depth] -> position * depth end)
  end

  def part2(args) do
    args
    |> format_input()
    |> Enum.reduce([0, 0, 0], fn {direction, value}, [position, depth, aim] ->
      val = String.to_integer(value)

      [
        position +
          case direction do
            "forward" -> val
            _ -> 0
          end,
        depth +
          case direction do
            "forward" -> aim * val
            _ -> 0
          end,
        aim +
          case direction do
            "down" -> val
            "up" -> -val
            _ -> 0
          end
      ]
    end)
    |> then(fn [position, depth, _aim] -> position * depth end)
  end

  def format_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn el -> el |> String.split(" ") |> List.to_tuple() end)
  end
end
