defmodule Day6 do
  defp read_and_parse do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ", ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve do
    list = read_and_parse()
    {max_x, max_y} = max_values(list)
    # Get every coordinate manhattan distance
    distances = Enum.map(0..max_x, fn x ->
      Enum.map(0..max_y, fn y ->
        Enum.map(list, fn l ->
          d = distance(l, [x, y])
          {d, l}
        end)
        |> Enum.sort_by(&Kernel.elem(&1, 0))
        |> Enum.slice(0, 2)
        |> case do
          [{x, _}, {y, _}] when x == y -> "."
          [{_, e}, _] -> e
        end
      end)
    end)

    left = Enum.at(distances, 0)
    right = Enum.at(distances, length(distances) -1)
    top = Enum.map(distances, &Enum.at(&1, 0))
    bottom = Enum.map(distances, &Enum.at(&1, length(&1) - 1))
    elements_to_remove = [left, right, top, bottom] |> Enum.concat |> Enum.uniq
    Enum.map(distances, fn column ->
      Enum.map(column, fn element ->
        if Enum.find_index(elements_to_remove, fn x -> x == element end) == nil do
          element
        else
          "."
        end
      end)
    end)
    |> Enum.concat
    |> Enum.sort
    |> Enum.chunk_by(&(&1))
    |> Enum.map(&length(&1))
    |> Enum.sort
    |> Enum.reverse
    |> Enum.at(1)
    |> IO.inspect
  end

  def max_values(list) do
    x = Enum.max_by(list, &Enum.at(&1, 0)) |> Enum.at(0)
    y = Enum.max_by(list, &Enum.at(&1, 1)) |> Enum.at(1)
    {x, y}
  end

  def solve2 do
    list = read_and_parse()
    {max_x, max_y} = max_values(list)
    # Get every coordinate manhattan distance
    Enum.map(0..max_x, fn x ->
      Enum.map(0..max_y, fn y ->
        Enum.map(list, fn l ->
          # Why [y, x] not [x, y] ? :D
          distance(l, [y, x])
        end)
        |> Enum.sum
        |> case do
          v when v < 10_000 -> "M"
          _other -> "."
        end
      end)
    end)
    |> Enum.concat
    |> Enum.filter(fn x -> x == "M" end)
    |> Enum.count
    |> IO.inspect
  end

  def distance([x1, y1 | _], [x2, y2 | _]) do
    Kernel.abs(x1 - x2) + Kernel.abs(y1 - y2)
  end
end

Day6.solve()
Day6.solve2()
