defmodule AdventOfCode.Day16 do
  defmodule Packet do
    defstruct [:version, :type, :value]
  end

  defp parse(args) do
    args
    |> String.trim()
    |> Base.decode16!()
  end

  defp decode(<<version::3, 4::3, rest::bitstring>>) do
    {value, rest} = decode_literal(rest, 0)
    {%Packet{type: :literal, version: version, value: value}, rest}
  end

  defp decode(<<version::3, type::3, 0::1, length::15, rest::bitstring>>) do
    <<subpackets::bitstring-size(length), rest::bitstring>> = rest

    {%Packet{type: type, version: version, value: decode_subpackets(subpackets)}, rest}
  end

  defp decode(<<version::3, type::3, 1::1, length::11, rest::bitstring>>) do
    {value, rest} = Enum.map_reduce(1..length, rest, fn _, acc -> decode(acc) end)
    {%Packet{type: type, version: version, value: value}, rest}
  end

  defp decode_subpackets(subpackets) do
    case decode(subpackets) do
      {packet, <<>>} -> [packet]
      {packet, rest} -> [packet | decode_subpackets(rest)]
    end
  end

  defp decode_literal(<<1::1, bits::4, rest::bitstring>>, acc) do
    decode_literal(rest, acc * 0x10 + bits)
  end

  defp decode_literal(<<0::1, bits::4, rest::bitstring>>, acc) do
    {acc * 0x10 + bits, rest}
  end

  defp sum_versions(%Packet{type: :literal, version: version}), do: version

  defp sum_versions(%Packet{version: version, value: value}) do
    Enum.reduce(value, version, &(sum_versions(&1) + &2))
  end

  def part1(args) do
    {packets, _} =
      args
      |> parse()
      |> decode()

    sum_versions(packets)
  end

  def part2(args) do
    {packets, _} =
      args
      |> parse()
      |> decode()

    evaluate(packets)
  end

  defp evaluate(%Packet{type: :literal, value: value}), do: value
  defp evaluate(%Packet{type: 0} = packet), do: reduce(packet, 0, &+/2)
  defp evaluate(%Packet{type: 1} = packet), do: reduce(packet, 1, &*/2)
  defp evaluate(%Packet{type: 2} = packet), do: reduce(packet, :inf, &min/2)
  defp evaluate(%Packet{type: 3} = packet), do: reduce(packet, 0, &max/2)
  defp evaluate(%Packet{type: 5} = packet), do: compare(packet, &>/2)
  defp evaluate(%Packet{type: 6} = packet), do: compare(packet, &</2)
  defp evaluate(%Packet{type: 7} = packet), do: compare(packet, &==/2)

  defp reduce(%Packet{value: value}, initial, op) do
    Enum.reduce(value, initial, &op.(evaluate(&1), &2))
  end

  defp compare(%Packet{value: [a, b]}, op) do
    if op.(evaluate(a), evaluate(b)), do: 1, else: 0
  end
end
