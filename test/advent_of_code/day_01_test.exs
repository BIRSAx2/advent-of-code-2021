defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  setup_all do
    input = AdventOfCode.Input.get!(1, 2021)
    {:ok, input: input}
  end

  test "part1", input do
    result = part1(input[:input])
    assert result == 1215
  end

  test "part2", input do
    result = part2(input[:input])

    assert result == 1150
  end
end
