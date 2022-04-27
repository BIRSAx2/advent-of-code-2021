defmodule AdventOfCode.Day08 do
  def parse(args) do
    args
    |> String.trim()
    |> String.split(["|", "\n"], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [pattern, output] ->
      {String.split(pattern), String.split(output)}
    end)
  end

  def part1(args) do
    args
    |> parse()
    |> Enum.map(fn {_input, output} ->
      Enum.count(output, &(String.length(&1) in [2, 3, 4, 7]))
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.map(fn {input, output} ->
      input = Enum.map(input, &to_charlist/1)
      output = Enum.map(output, &to_charlist/1)

      # known by their length
      one = Enum.find(input, &(length(&1) == 2))
      four = Enum.find(input, &(length(&1) == 4))
      seven = Enum.find(input, &(length(&1) == 3))
      eight = Enum.find(input, &(length(&1) == 7))

      # numbers with a length of 6
      six_nine_zero = Enum.filter(input, &(length(&1) == 6))

      six = Enum.find(six_nine_zero, &(length(&1 -- one) == 5))

      nine = Enum.find(six_nine_zero, &(length(&1 -- four) == 2))

      zero = Enum.find(six_nine_zero, &(&1 != nine && &1 != six))

      # numbers with a length of 5
      two_three_five = Enum.filter(input, &(length(&1) == 5))

      five = Enum.find(two_three_five, &(length(six -- &1) == 1))

      three = Enum.find(two_three_five, &(length(nine -- &1) == 1 && &1 != five))

      two = Enum.find(two_three_five, &(&1 != three && &1 != five))

      unique_patterns = [zero, one, two, three, four, five, six, seven, eight, nine]

      output
      |> Enum.map(fn digit ->
        unique_patterns
        |> Enum.with_index()
        |> Enum.find(fn {num, _val} ->
          length(num) == length(digit) && num -- digit == []
        end)
        |> then(fn {_, val} -> val end)
      end)
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end
end
