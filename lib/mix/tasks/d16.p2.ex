defmodule Mix.Tasks.D16.P2 do
  use Mix.Task

  import AdventOfCode.Day16

  @shortdoc "Day 16 Part 2"
  def run(args) do
    input = """
    9C0141080250320F1802104A08
    """

    # input = AdventOfCode.Input.get!(16, 2021)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
