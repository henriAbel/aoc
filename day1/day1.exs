defmodule Day1 do

  def parse() do
    File.read!("./input_1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<action::binary-size(1), number::binary>> ->
      number = number |> String.to_integer
      case action do
        "+" -> number
        _other -> number * -1
      end
    end)
  end

  def solve() do
    parse()
    |> Enum.sum
    |> IO.inspect
  end

  def solve2() do
    parse()
    |> Stream.cycle
    |> Enum.reduce_while(%{0 => 0, frequency: 0}, fn x, acc ->
      new_freq = Map.get(acc, :frequency) + x
      case Map.get(acc, new_freq) do
        nil ->
          acc = acc
          |> Map.put(new_freq, 1)
          |> Map.put(:frequency, new_freq)
          {:cont, acc}
        _other ->
          {:halt, new_freq}
      end
    end)
    |> IO.inspect
  end
end

Day1.solve()
Day1.solve2()
