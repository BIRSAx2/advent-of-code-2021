defmodule AdventOfCode.Day16 do
  defp parse(args) do
    parsed =
      args
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.map(fn digits ->
        digits
        |> String.to_integer(16)
        |> Integer.digits(2)
        |> Enum.join()
        |> String.pad_leading(4, "0")
      end)
      |> List.flatten()
      |> Enum.join()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1, 2))

    parsed
  end

  defp to_hex() do
  end

  def part1(args) do
    packets =
      parse(args)
      |> parse_packets()
      |> Enum.map(&Map.get(&1, :version))
      |> Enum.sum()
  end

  defp parse_packets(packets) do
    {parsed, _} =
      packets
      |> Enum.reduce(
        {[], %{}},
        fn bit, {parsed, current} ->
          current =
            cond do
              # Common header
              length(Map.get(current, :version, [])) < 3 ->
                Map.update(current, :version, [bit], &(&1 ++ [bit]))

              length(Map.get(current, :type, [])) < 3 ->
                Map.update(current, :type, [bit], &(&1 ++ [bit]))

              # Handling literal packets
              Integer.undigits(Map.get(current, :type), 2) == 4 and
                  not Map.get(current, :groups_end, false) ->
                current = Map.update(current, :current_group, [bit], &(&1 ++ [bit]))
                # length(Map.get(current, :groups)) |> IO.write()

                group = Map.get(current, :current_group, [])

                cond do
                  length(group) == 5 and hd(group) == 0 ->
                    current
                    |> Map.update(
                      :groups,
                      [tl(Map.get(current, :current_group))],
                      &(&1 ++ [tl(Map.get(current, :current_group))])
                    )
                    |> Map.put(:current_group, [])
                    |> Map.put(:groups_end, true)

                  length(group) == 5 ->
                    current
                    |> Map.update(
                      :groups,
                      [tl(Map.get(current, :current_group))],
                      &(&1 ++ [tl(Map.get(current, :current_group))])
                    )
                    |> Map.put(:current_group, [])

                  true ->
                    current
                end

              # handling operator packets
              Map.get(current, :length_type, nil) == nil ->
                Map.put(current, :length_type, bit)

              Map.get(current, :length_type) == 0 and
                  length(Map.get(current, :total_length, [])) < 15 ->
                Map.update(current, :total_length, [bit], &(&1 ++ [bit]))

              Map.get(current, :length_type) == 1 and
                  length(Map.get(current, :number_of_subpackets, [])) < 11 ->
                Map.update(current, :number_of_subpackets, [bit], &(&1 ++ [bit]))

              true ->
                current
            end

          cond do
            Map.get(current, :groups_end, false) ->
              value = Map.get(current, :groups) |> List.flatten() |> Integer.undigits(2)
              current = Map.put(current, :value, value)
              {parsed ++ [current], %{}}

            length(Map.get(current, :total_length, [])) == 15 ->
              current = Map.update!(current, :total_length, &Integer.undigits(&1, 2))

              {parsed ++ [current], %{}}

            length(Map.get(current, :number_of_subpackets, [])) == 11 ->
              current = Map.update!(current, :number_of_subpackets, &Integer.undigits(&1, 2))

              {parsed ++ [current], %{}}

            true ->
              {parsed, current}
          end
        end
      )

    parsed
    |> Enum.map(fn packet ->
      packet
      |> Map.keys()
      |> Enum.reduce(packet, fn key, packet ->
        if(is_list(Map.get(packet, key))) do
          Map.put(packet, key, Integer.undigits(List.flatten(Map.get(packet, key)), 2))
        else
          packet
        end
      end)
    end)
  end

  def part2(args) do
    packets =
      args
      |> parse()
      |> parse_packets()
      |> IO.inspect(label: "parsed packets")

    nil
  end
end
