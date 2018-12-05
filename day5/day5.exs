defmodule Day5 do
  defp read_and_parse do
    File.read!("input.txt")
    |> String.graphemes
  end

  def solve do
    read_and_parse()
    |> get_reaction_length()
    |> IO.inspect
  end

  def solve2 do
    input = File.read!("input.txt")
    (for n <- ?a..?z, do: << n :: utf8 >>)
    |> Enum.map(fn c ->
      input
      # Replace ignoring case
      |> String.replace(~r/#{c}/i, "")
      |> String.graphemes()
      |> get_reaction_length()
    end)
    |> Enum.sort
    |> List.first
    |> IO.inspect
  end

  def get_reaction_length(polymer) do
    Enum.reduce(polymer, [], fn
      head, [] -> [head]
      x, [yx | ys] ->
        # Chars are not the same but the downcase version of those chars are
        if x != yx && String.downcase(x) == String.downcase(yx) do
          ys
        else
          [x, yx | ys]
        end
    end)
    |> length
  end
end

Day5.solve()
Day5.solve2()
