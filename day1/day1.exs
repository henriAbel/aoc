defmodule Day1 do
  def solve() do
    File.read!("./input_1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<action::binary-size(1), number::binary>> ->
      number = number |> String.to_integer
      case action do
        "+" -> number
        _other -> number * -1
      end
    end)
    |> Enum.sum
    |> IO.inspect
  end

  def solve2() do

  end
end

Day1.solve()
Day1.solve2()
