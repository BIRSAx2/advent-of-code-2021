defmodule AdventOfCode.Day18 do
  defp parse(args) do
    args
    |> String.trim()
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))
  end

  def add(a, b) do
    [a, b] |> reduce()
  end

  def merge([left, right], next) do
    [left, merge(right, next)]
  end

  def merge(prev, [left, right]) do
    [merge(prev, left), right]
  end

  def merge(left, right) do
    left + right
  end

  def reduce(snailfish_number) do
    cond do
      snailfish_number = explode(snailfish_number) ->
        {_, snailfish_number, _} = snailfish_number
        reduce(snailfish_number)

      snailfish_number = split(snailfish_number) ->
        reduce(snailfish_number)

      true ->
        snailfish_number
    end
  end

  def explode(_, level \\ 0)

  def explode([left, right], 4) do
    {left, 0, right}
  end

  def explode([left, right], level) do
    with {left_left, n, left_right} <- explode(left, level + 1) do
      {left_left, [n, merge(left_right, right)], 0}
    end ||
      with {left_right, n, right_right} <- explode(right, level + 1) do
        {0, [merge(left, left_right), n], right_right}
      end
  end

  def explode(_, _) do
    false
  end

  def split([left, right]) do
    cond do
      left_left = split(left) ->
        [left_left, right]

      right_right = split(right) ->
        [left, right_right]

      true ->
        false
    end
  end

  def split(snailfish_digit) when snailfish_digit >= 10 do
    half = div(snailfish_digit, 2)
    [half, snailfish_digit - half]
  end

  def split(_snailfish_digit) do
    false
  end

  def magnitude([left, right]) when is_integer(left) and is_integer(right) do
    3 * left + 2 * right
  end

  def magnitude([left, right]) when is_integer(left) and is_list(right) do
    magnitude([left, magnitude(right)])
  end

  def magnitude([left, right]) when is_list(left) and is_integer(right) do
    magnitude([magnitude(left), right])
  end

  def magnitude([left, right]) do
    magnitude([magnitude(left), magnitude(right)])
  end

  def part1(args) do
    parse(args)
    |> Enum.reduce(&add(&2, &1))
    |> magnitude()
  end

  def part2(args) do
    snailfish_numbers = parse(args)

    for operand_1 <- snailfish_numbers, operand_2 <- snailfish_numbers, operand_1 != operand_2 do
      [
        magnitude(add(operand_1, operand_2)),
        magnitude(add(operand_2, operand_1))
      ]
    end
    |> List.flatten()
    |> Enum.max()
  end
end
