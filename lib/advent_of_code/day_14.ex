defmodule AdventOfCode.Day14 do
  defp parse(args) do
    [polymer_template, pair_insertions] = String.split(args, "\n\n", trim: true)

    polymer_template = String.split(polymer_template, "", trim: true)

    pair_insertions =
      pair_insertions
      |> String.split("\n", trim: true)
      |> Enum.map(&(String.split(&1, " -> ", trim: true) |> List.to_tuple()))
      |> Enum.into(%{})

    {polymer_template, pair_insertions}
  end

  defp find_polymer(polymer_template, pair_insertions, steps) do
    template =
      polymer_template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&Enum.join/1)
      |> Enum.frequencies()

    frequencies =
      1..steps
      |> Enum.reduce(template, fn _, template ->
        template
        |> Enum.reduce(%{}, fn {pair, count}, freq ->
          letter = Map.get(pair_insertions, pair)

          first_new_pair = String.at(pair, 0) <> letter
          second_new_pair = letter <> String.at(pair, 1)

          freq
          |> Map.update(first_new_pair, count, &(&1 + count))
          |> Map.update(second_new_pair, count, &(&1 + count))
        end)
      end)

    frequencies =
      Enum.reduce(frequencies, %{}, fn {k, count}, acc ->
        Map.update(acc, String.at(k, 0), count, &(&1 + count))
      end)

    # adding 1 to the last item
    Map.update!(frequencies, List.last(polymer_template), &(&1 + 1))
  end

  def part1(args) do
    {polymer_template, pair_insertions} = parse(args)
    steps = 10

    {least_common_count, most_common_count} =
      find_polymer(polymer_template, pair_insertions, steps)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.min_max()

    most_common_count - least_common_count
  end

  def part2(args) do
    {polymer_template, pair_insertions} = parse(args)
    steps = 40

    {least_common_count, most_common_count} =
      find_polymer(polymer_template, pair_insertions, steps)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.min_max()

    most_common_count - least_common_count
  end
end
