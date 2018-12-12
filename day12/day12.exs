defmodule Day12 do

  @generations 20

  def read_and_parse() do
    all_lines = File.read!("input.txt")
    |> String.split("\n", trim: true)

    initial_state = Enum.at(all_lines, 0) |> String.slice(15..-1)
    rules = Enum.slice(all_lines, 1..-1)
    |> Enum.map(fn rule ->
      String.split(rule, "=>") |> Enum.map(&String.trim/1)
    end)
    {"...." <> initial_state <> String.duplicate("..", @generations), rules}
  end

  def solve do
    {initial_state, rules} = read_and_parse()
    last_generation = Enum.reduce(1..@generations, initial_state, fn x, acc ->
      IO.inspect ("#{x}: #{acc}")
      evolve(acc, rules)
    end)

    Enum.reduce(last_generation |> String.graphemes |> Stream.with_index(-4), 0, fn {x, index}, acc ->
      case x do
        "." -> acc
        "#" -> acc + index
      end
    end)
    |> IO.inspect
  end

  def solve2 do

  end

  def evolve(state, rules) do
    state
    |> String.graphemes |> Enum.with_index |> Enum.map(fn {_pot, index} ->

      this = String.slice(state, index-2..index+2)
      case Enum.find(rules, fn [x, _] -> x == this end) do
        nil -> "."
        [_rule, replacement] -> replacement
      end
    end)
    |> Enum.join
  end
end

Day12.solve()
Day12.solve2()
