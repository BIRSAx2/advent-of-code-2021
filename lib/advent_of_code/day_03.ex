defmodule AdventOfCode.Day03 do
  use Bitwise

  def parse(input) do
    input
    |> String.split("\n", trim: true)
  end

  def part1(args) do
    args
    |> parse()
    |> frequencies()
    |> Enum.reduce([0, 0], &calculate_rates/2)
    |> Enum.reduce(&(&1 * &2))
  end

  def calculate_rates(el, [gamma_rate, epsilon_rate]) do
    {{gamma, _}, {epsilon, _}} =
      el
      |> Enum.min_max_by(fn {_key, value} -> value end)

    [(gamma_rate <<< 1) + gamma, (epsilon_rate <<< 1) + epsilon]
  end

  defp frequencies(samples) do
    bit_per_sample = String.length(hd(samples))

    # digits =
    #   samples
    #   |> Enum.map(&(&1 |> String.to_charlist() |> List.to_tuple()))

    # for pos <- 0..(bit_per_sample - 1) do
    #   Enum.map(digits, &elem(&1, pos))
    # end
    # |> IO.inspect()

    0..(bit_per_sample - 1)
    |> Enum.map(fn i ->
      Enum.map(samples, fn sample ->
        String.at(sample, i) |> String.to_integer()
      end)
      |> IO.inspect()
      |> Enum.frequencies()
      |> Map.to_list()
    end)
  end

  def part2(args) do
    samples =
      args
      |> parse()

    bit_per_sample = String.length(hd(samples))

    [[oxygen_rating], _] =
      samples
      |> Enum.reduce_while([samples, 0], fn _el, [filtered, index] ->
        {condition, _} =
          filtered
          |> frequencies()
          |> Enum.at(index)
          |> Enum.sort(:desc)
          |> Enum.max_by(fn {_key, value} -> value end)

        filtered =
          filtered
          |> Enum.filter(fn el ->
            String.at(el, index) ==
              "#{condition}"
          end)

        if(length(filtered) <= 1) do
          {:halt, [filtered, index + 1]}
        else
          {:cont, [filtered, index + 1]}
        end
      end)

    [[co2_rating], _] =
      samples
      |> Enum.reduce_while([samples, 0], fn _el, [filtered, index] ->
        {condition, _} =
          filtered
          |> frequencies()
          |> Enum.at(index)
          |> Enum.min_by(fn {_key, value} -> value end)

        filtered =
          filtered
          |> Enum.filter(fn el ->
            String.at(el, index) ==
              "#{condition}"
          end)

        if(length(filtered) <= 1) do
          {:halt, [filtered, index + 1]}
        else
          {:cont, [filtered, index + 1]}
        end
      end)

    String.to_integer(oxygen_rating, 2) * String.to_integer(co2_rating, 2)
  end
end
