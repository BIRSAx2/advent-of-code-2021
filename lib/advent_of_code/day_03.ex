defmodule AdventOfCode.Day03 do
  use Bitwise

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> String.to_charlist() |> List.to_tuple()))
  end

  def part1(args) do
    samples = parse(args)

    [sample | _] = samples

    bit_per_sample = tuple_size(sample)

    half = div(length(samples), 2)

    gamma =
      for index <- 0..(bit_per_sample - 1) do
        zero_count = Enum.count_until(samples, &(elem(&1, index) == ?0), half + 1)
        if zero_count > half, do: ?0, else: ?1
      end
      |> List.to_integer(2)

    mask = 2 ** bit_per_sample - 1

    epsilon = ~~~gamma &&& mask

    gamma * epsilon
  end

  def part2(args) do
    samples = parse(args)
    o2 = recur(samples, :most_common)
    co2 = recur(samples, :least_common)
    o2 * co2
  end

  defp recur(samples, mode) do
    recur(samples, 0, mode)
  end

  defp recur([number], _index, _mode) do
    number
    |> Tuple.to_list()
    |> List.to_integer(2)
  end

  defp recur(samples, index, mode) do
    zero_count = Enum.count(samples, &(elem(&1, index) == ?0))
    one_count = length(samples) - zero_count

    to_keep =
      case mode do
        :most_common -> if one_count >= zero_count, do: ?1, else: ?0
        :least_common -> if zero_count > one_count, do: ?1, else: ?0
      end

    samples = Enum.filter(samples, &(elem(&1, index) == to_keep))

    recur(samples, index + 1, mode)
  end
end
