defmodule Day7 do
  defp read_and_parse do
    tree = File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {
        String.at(line, 5),
        String.at(line, 36)
      }
    end)
    |> Enum.reduce(%{}, fn {prerequisite, step}, acc ->
      {_, map} = Map.get_and_update(acc, step, fn current_value ->
        case current_value do
          nil ->
            {current_value, [prerequisite]}
          value ->
            {current_value, [prerequisite | value]}
        end
      end)
      map
    end)

    get_missing_left(tree)
    |> Enum.reduce(tree, fn x, acc ->
      Map.put(acc, x, [])
    end)
  end

  def solve do
    tree = read_and_parse()

    {_state, answer} = Enum.reduce(0..map_size(tree) - 1, {tree, []}, fn _, {working_tree, steps_done} ->
      next_step = get_next_step(working_tree, steps_done)

      dependencies = Enum.filter(working_tree, fn {_key, val} -> Enum.member?(val, next_step) end)
      working_tree = Enum.reduce(dependencies, working_tree, fn {key, _val}, acc ->
        Map.update!(acc, key, fn x ->
          List.delete(x, next_step)
        end)
      end)


      {working_tree, [next_step | steps_done]}
    end)

    Enum.reverse(answer)
    |> Enum.join
    |> IO.inspect
  end

  def steps(list) do
    Enum.map(list, fn {a, _b} -> a end)
    |> Enum.uniq
  end

  def get_next_step(list, done) do
    steps(list)
    |> Enum.filter(fn x -> !Enum.member?(done, x) end)
    |> Enum.reduce([], fn x, acc ->
      case Map.get(list, x) do
        [] -> [x | acc]
        _other -> acc
      end
    end)
    |> Enum.sort
    |> List.first
  end

  def get_missing_left(tree) do
    right = Enum.map(tree, fn {_a, b} -> b end)
    |> Enum.concat
    |> Enum.uniq
    left = Enum.map(tree, fn {a, _b} -> a end)

    right -- left
  end

  def solve2 do
  end
end

Day7.solve()
Day7.solve2()

