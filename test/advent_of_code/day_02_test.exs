defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  setup_all do
    input = AdventOfCode.Input.get!(2, 2021)
    {:ok, input: input}
  end

  test "part1", input do
    result = part1(input[:input])

    assert result == 1_480_518
  end

  @tag :skip
  test "part2", input do
    result = part1(input[:input])
    assert result == 0
  end
end
