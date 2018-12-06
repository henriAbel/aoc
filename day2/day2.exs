defmodule Day2 do

  def parse() do
    File.read!("./input.txt")
    |> String.split("\n", trim: true)
  end

  def solve() do
    parse()
    |> Enum.map(&String.graphemes(&1))
    |> Enum.map(fn id ->
      Enum.group_by(id, fn x -> x end)
      |> Enum.map(fn {k, v} ->
        {k, length(v)}
      end)
      |> Enum.filter(fn {_k, v} -> v >= 2 end)
      |> Enum.uniq_by(fn {_letter, count} -> count end)
    end)
    |> Enum.map(fn line ->
      Enum.reduce(line, {0, 0}, fn {_letter, count}, {two, three} ->
        case count do
          2 -> {two + 1, three}
          3 -> {two, three + 1 }
          _ -> {two, three}
        end
      end)
    end)

    |> Enum.reduce({0, 0}, fn {x1, y2}, {x, y} ->
      {x1 + x, y2 + y}
    end)
    |> (fn {x, y} -> x * y end).()
    |> IO.inspect
  end

  def solve2() do
    lines = parse()
    distances = lines
    |> Enum.map(fn line ->
      letters = String.graphemes(line)
      lines |> Enum.map(fn x ->
        {distance, _} = x |> String.graphemes |> Enum.reduce({0, 0}, fn y, {count, index} ->
          # Could use arr1 -- arr2 but edge case when some letters are removed multiple times
          if Enum.at(letters, index) == y do
            {count, index + 1}
          else
            {count + 1, index + 1}
          end
        end)
        {distance, x}
      end)
      |> Enum.sort_by(fn {val, _string} -> val end)
      |> Enum.at(1) # 0 is element distance to self
    end)

    minimal_element = distances
    |> Enum.min_by(fn {x, _} -> x end)

    [{_, word1}, {_, word2}] = Enum.filter(distances, fn {x, _} -> x == Kernel.elem(minimal_element, 0) end)
    (word1 |> String.graphemes) -- (word2 |> String.graphemes)
    |> Enum.reduce(word1, fn x, acc ->
      String.replace(acc, x, "")
    end)
    |> IO.inspect
  end
end

Day2.solve()
Day2.solve2()
