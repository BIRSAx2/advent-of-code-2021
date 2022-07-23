defmodule AdventOfCode.Day21 do
  defp parse(args) do
    Regex.scan(~r/\d+/, args)
    |> List.flatten()
    |> then(fn [_, p1, _, p2] -> [p1, p2] end)
    |> Enum.map(&String.to_integer/1)
  end

  defp play_with_deterministic_die(players, last_roll \\ 1)

  defp play_with_deterministic_die([{_, loser_score}, {_, winner_score}], last_roll)
       when winner_score >= 1000 do
    loser_score * (last_roll - 1)
  end

  defp play_with_deterministic_die([{position, score}, next_player], next_roll) do
    position = rem(position + 3 * next_roll + 3, 10)
    score = score + position + 1

    play_with_deterministic_die([next_player, {position, score}], next_roll + 3)
  end

  def part1(args) do
    [pos_1, pos_2] = parse(args)

    # removing 1 from the initial positions to make them 0-based
    players = [{pos_1 - 1, 0}, {pos_2 - 1, 0}]

    play_with_deterministic_die(players)
  end

  defp play_with_quantum_die({_position_1, _score_1}, {_p2, score_2}, _roll_frequency)
       when score_2 <= 0,
       # player_2 as won
       do: [0, 1]

  defp play_with_quantum_die({position_1, score_1}, {position_2, score_2}, roll_frequency) do
    roll_frequency
    |> Enum.reduce([0, 0], fn {roll, freq}, [wins_1, wins_2] ->
      [c2, c1] =
        play_with_quantum_die(
          {position_2, score_2},
          {rem(position_1 + roll, 10), score_1 - 1 - rem(position_1 + roll, 10)},
          roll_frequency
        )

      # wins_j is the number of universes where player_j wins
      [
        wins_1 + freq * c1,
        wins_2 + freq * c2
      ]
    end)
  end

  def part2(args) do
    [pos_1, pos_2] = parse(args)

    roll_frequency =
      for a <- [1, 2, 3], b <- [1, 2, 3], c <- [1, 2, 3] do
        a + b + c
      end
      |> Enum.frequencies()
      |> Map.to_list()

    # removing 1 from the initial positions to make them 0-based

    play_with_quantum_die({pos_1 - 1, 21}, {pos_2 - 1, 21}, roll_frequency)
    |> Enum.max()
  end
end
