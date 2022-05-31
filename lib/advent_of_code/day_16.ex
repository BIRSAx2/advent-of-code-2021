defmodule AdventOfCode.Day16 do
  defp parse(args) do
    parsed =
      args
      |> String.trim()
      |> String.to_integer(16)
      |> Integer.digits(2)

    expected_length = 4 * ceil(length(parsed) / 4)

    packet_length = length(parsed)

    padding =
      cond do
        expected_length == packet_length -> []
        true -> for _i <- 1..(expected_length - packet_length), do: 0
      end

    padding ++ parsed
  end

  def part1(args) do
    packets =
      parse(args)
      |> parse_packet()

    packets
    |> Enum.map(&Map.get(&1, :version))
    |> Enum.sum()
  end

  defp parse_packet(packet, packets \\ [])
  defp parse_packet([], packets), do: packets

  defp parse_packet(packet, packets) do
    if Enum.all?(packet, &(&1 == 0)) do
      parse_packet([])
    else
      [version, type_id] =
        packet
        |> Enum.take(6)
        |> Enum.chunk_every(3)
        |> Enum.map(&Integer.undigits(&1, 2))

      p = %{version: version, type_id: type_id}

      packets = [p | packets]

      payload = Enum.drop(packet, 6)

      payload = if Enum.all?(payload, &(&1 == 0)), do: [], else: payload

      parse_payload(payload, type_id, packets)
    end
  end

  defp parse_payload(payload, 4, [current_packet | packets]) do
    payload = Enum.chunk_every(payload, 5)

    [h | new_payload] = Enum.drop_while(payload, fn g -> not List.starts_with?(g, [0]) end)

    groups = Enum.take_while(payload, fn g -> not List.starts_with?(g, [0]) end) ++ [h]
    payload = new_payload |> List.flatten()

    literal_value =
      groups
      |> Enum.map(&tl/1)
      |> List.flatten()
      |> Integer.undigits(2)

    packets = [Map.put(current_packet, :value, literal_value) | packets]
    payload = if Enum.all?(payload, &(&1 == 0)), do: [], else: payload

    parse_packet(payload, packets)
  end

  defp parse_payload(payload, _type, packets) do
    [length_type_id | payload] = payload

    {length_sub_packet, payload} =
      case length_type_id do
        0 ->
          {
            Enum.take(payload, 15),
            Enum.drop(payload, 15)
          }

        1 ->
          {Enum.take(payload, 11), Enum.drop(payload, 11)}
      end

    length_sub_packet = Integer.undigits(length_sub_packet, 2)

    new_payload = if length_type_id == 1, do: payload, else: Enum.take(payload, length_sub_packet)

    payload = if Enum.all?(payload, &(&1 == 0)), do: [], else: payload

    packets =
      if length_type_id != 1,
        do: parse_packet(Enum.drop(payload, length_sub_packet), packets),
        else: packets

    new_payload = if Enum.all?(new_payload, &(&1 == 0)), do: [], else: payload

    parse_packet(new_payload, packets)
  end

  def part2(args) do
    packets =
      parse(args)
      |> parse_packet()
      |> IO.inspect(label: "lib/advent_of_code/day_16.ex:112")

    packets
    |> Enum.map(&Map.get(&1, :version))
    |> Enum.sum()
  end
end
