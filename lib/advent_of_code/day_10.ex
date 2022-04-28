defmodule AdventOfCode.Day10 do
  @opening_braces ["(", "<", "[", "{"]
  @closing_braces %{")" => "(", ">" => "<", "]" => "[", "}" => "{"}

  defp parse(args) do
    args
    |> String.split("\n", trim: true)
  end

  def part1(args) do
    args
    |> parse()
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.reduce_while({[], nil}, fn brace, {opened, _first_incorret} ->
        if brace in @opening_braces do
          {:cont, {[brace | opened], nil}}
        else
          # stack behaviour
          [last | rest] =
            case length(opened) do
              0 -> [nil, nil]
              1 -> [hd(opened), nil]
              _ -> opened
            end

          if Map.get(@closing_braces, brace) == last do
            {:cont, {rest, nil}}
          else
            {:halt, {rest, brace}}
          end
        end
      end)
    end)
    |> Enum.map(fn {_, first_incorrect} ->
      first_incorrect
    end)
    |> Enum.filter(&(&1 != nil))
    |> calculate_points()
  end

  defp calculate_points(braces) do
    braces
    |> Enum.frequencies()
    |> Enum.map(fn {brace, count} ->
      count *
        case brace do
          ")" -> 3
          "]" -> 57
          "}" -> 1197
          ">" -> 25137
        end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    braces = %{"(" => ")", "<" => ">", "[" => "]", "{" => "}"}

    scores =
      args
      |> parse()
      |> Enum.filter(&is_incorrect(&1))
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.reduce([], fn brace, open_braces ->
          if brace in @opening_braces do
            [brace | open_braces]
          else
            # stack behaviour
            [last | rest] =
              case length(open_braces) do
                0 -> [nil, nil]
                1 -> [hd(open_braces), nil]
                _ -> open_braces
              end

            if Map.get(@closing_braces, brace) == last do
              rest
            else
              open_braces
            end
          end
        end)
      end)
      |> Enum.map(fn open_braces ->
        open_braces
        |> Enum.map(&Map.get(braces, &1))
      end)
      |> Enum.map(fn line ->
        line
        |> Enum.filter(&(&1 != nil))
        |> Enum.reduce(0, fn brace, acc ->
          value =
            case brace do
              ")" -> 1
              "]" -> 2
              "}" -> 3
              ">" -> 4
            end

          acc * 5 + value
        end)
      end)
      |> Enum.sort()

    middle_index = scores |> length() |> div(2)
    Enum.at(scores, middle_index)
  end

  defp is_incorrect(line) do
    {_, first_incorrect} =
      line
      |> String.split("", trim: true)
      |> Enum.reduce_while({[], nil}, fn brace, {opened, _first_incorret} ->
        if brace in @opening_braces do
          {:cont, {[brace | opened], nil}}
        else
          # stack behaviour
          [last | rest] =
            case length(opened) do
              0 -> [nil, nil]
              1 -> [hd(opened), nil]
              _ -> opened
            end

          if Map.get(@closing_braces, brace) == last do
            {:cont, {rest, nil}}
          else
            {:halt, {rest, brace}}
          end
        end
      end)

    first_incorrect == nil
  end
end
