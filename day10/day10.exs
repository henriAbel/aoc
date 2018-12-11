defmodule Day10 do
  defp read_and_parse do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.run(~r/(-?\d+)\D+?(-?\d+)\D+?(-?\d+)\D+?(-?\d+)/, line)
      |> Enum.slice(1, 4)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn line ->
      %{
        position: { Enum.at(line, 0), Enum.at(line, 1) },
        velocity: { Enum.at(line, 2), Enum.at(line, 3) }
      }
    end)
  end

  def solve do
    data = read_and_parse()
    Enum.reduce_while(1..20000, data, fn second, acc ->
      acc
      |> tick
      |> print
      |> case do
        {:halt, x} ->
          IO.puts "Seconds: #{second}"
          {:halt, x}
        other -> other
      end
    end)
  end

  def tick(points) do
    Enum.map(points, fn %{position: {x, y}, velocity: {tx, ty}} ->
      %{position: {x + tx, y + ty}, velocity: {tx, ty}}
    end)
  end

  def print(points) do
    {%{position: {min_x, _}}, %{position: {max_x, _}}} = Enum.min_max_by(points, fn p -> elem(Map.get(p, :position), 0) end)
    {%{position: {_, min_y}}, %{position: {_, max_y}}} = Enum.min_max_by(points, fn p -> elem(Map.get(p, :position), 1) end)

    height = max_y - min_y
    # Magic number
    if height > 10 do
      {:cont, points}
    else
      for y <- min_y..max_y do
        for x <- min_x..max_x do
          case Enum.find(points, fn p ->
            {px, py} = Map.get(p, :position)
            px == x and py == y end) do
            nil -> " "
            _other -> "#"
          end
          |> IO.write
        end
        IO.write("\n")
      end
      {:halt, points}
    end
  end
end

Day10.solve()
