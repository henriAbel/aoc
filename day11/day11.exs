defmodule Day11 do

  @input 7989
  #@input 42
  @grid_size 300

  def solve do
    {_, total_power, pos} = Enum.map(1..@grid_size, fn y ->
      Enum.map(1..@grid_size, fn x ->
        # Find 3 x 3 square power
        Enum.reduce(y..y + 2, 0, fn yy, acc ->
          acc + Enum.reduce(x..x + 2, 0, fn xx, acc ->
            acc + power_level(xx, yy)
          end)
        end)
      end)
    end)
    |> Enum.reduce({0, 0, nil}, fn x, {posy, max_val, max_pos} ->
      {_, max_sub_val, max_sub_pos} = Enum.reduce(x, {0, 0, nil}, fn y, {posx, max_val, max_pos} ->
        reducer1(y, max_val, max_pos, {posx + 1, posy + 1}, posx)
      end)
      reducer1(max_sub_val, max_val, max_pos, max_sub_pos, posy)
    end)

    IO.puts "The largest total 3x3 square has a top-left corner of #{inspect pos} (with a total power of #{total_power})"
  end

  def solve2 do
    {_, total_power, pos} = Enum.map(1..@grid_size, fn y ->
      Enum.map(1..@grid_size, fn x ->
        # Find best power of all squares
        max_size = Enum.min([@grid_size - y, @grid_size - x, 20])
        Enum.map(1..max_size, fn n ->
          grid_power = Enum.reduce(y..y + n, 0, fn yy, acc ->
            acc + Enum.reduce(x..x + n, 0, fn xx, acc ->
              acc + power_level(xx, yy)
            end)
          end)
          {grid_power, n + 1}
        end)
        |> Enum.max_by(fn {grid_power, _n} -> grid_power end)
      end)
    end)
    |> Enum.reduce({0, 0, nil}, fn x, {posy, max_val, max_pos} ->
      {_, max_sub_val, max_sub_pos} = Enum.reduce(x, {0, 0, nil}, fn {grid_power, n}, {posx, max_val, max_pos} ->
        reducer1(grid_power, max_val, max_pos, {posx + 1, posy + 1, n}, posx)
      end)
      reducer1(max_sub_val, max_val, max_pos, max_sub_pos, posy)
    end)

    IO.puts "The largest total 3x3 square has a top-left corner of #{inspect pos} (with a total power of #{total_power})"
  end

  def reducer1(val, max_val, current_max_pos, new_max_pos, counter) do
    if val > max_val do
      {counter + 1, val, new_max_pos}
    else
      {counter + 1, max_val, current_max_pos}
    end
  end

  def power_level(x, y) do
    rack_id = x + 10
    power_level_start = rack_id * y
    step3 = power_level_start + @input
    step5 = step3 * rack_id
    |> div(100)
    |> rem(10)
    step5 - 5
  end

end

Day11.solve()
Day11.solve2()
