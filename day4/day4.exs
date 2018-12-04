defmodule Day4 do
  def read_and_parse() do
    File.read!("./input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn (<<
      "[",
      year::bytes-size(4),
      _::binary-size(1), # -
      month::bytes-size(2),
      _::binary-size(1), # -
      day::bytes-size(2),
      _::binary-size(1), # space
      hour::bytes-size(2),
      _::binary-size(1), # :
      minute::bytes-size(2),
      "] ",
      action::binary>>) ->

      {:ok, date} = NaiveDateTime.new(
        year    |> String.to_integer,
        month   |> String.to_integer,
        day     |> String.to_integer,
        hour    |> String.to_integer,
        minute  |> String.to_integer, 0)
      {date, action}
    end)
    |> Enum.sort_by(&(NaiveDateTime.to_erl(elem(&1, 0))))
  end

  def group_guards(list) do
    Enum.reduce(list, %{}, fn {_date, action} = row, acc ->
      case action |> String.replace(" begins shift", "") do
        <<"Guard #", id::binary>> ->
          # Add new shift, index 0
          shifts = [[row] | Map.get(acc, id, [])]
          acc
          |> Map.put(id, shifts)
          |> Map.put(:sp, id)
        _other ->
          id = Map.get(acc, :sp)
          # Update first shift in array
          update_in(acc, [Access.key!(id), Access.at(0)], fn shift ->
            shift ++ [row]
          end)
      end
    end)
    |> Map.delete(:sp)
  end

  def calculate_total_sleep(list) do
    Map.keys(list)
    |> Enum.map(fn guard ->
      slept_time = Map.get(list, guard)
      |> Enum.reduce([], fn shift, acc ->
        {minutes, _} = Enum.reduce(shift, {[], nil}, fn {date, action}, {slept_hours, prev_date} = acc ->
          case action do
            "wakes up" ->
              diff = NaiveDateTime.diff(date, prev_date, :seconds) / 60
              start_time = NaiveDateTime.to_time(prev_date)
              m = Enum.map(0..Kernel.round(diff) - 1, fn minute ->
                {_hour, minute_value, _second} = Time.add(start_time, minute * 60)
                |> Time.to_erl
                # For some reason if this function returns int array it will be interpreted as string. Dividing with 1 will make value to float
                minute_value / 1
              end)
              {Enum.concat(m, slept_hours), nil}
            "falls asleep" ->
              {slept_hours, date}
            _shift_start ->
              acc
          end
        end)
        Enum.concat(acc, minutes)
      end)
      {guard, slept_time}
    end)
  end

  def best_sleep_minute(guards) do
    Enum.map(guards, fn {guard_id, minutes} ->
      case minutes do
        [] -> {guard_id, -1, -1}
        _other ->
          {highest_values, highest_count} = most_common_element(minutes)
          {guard_id, highest_values, highest_count}
      end
    end)
  end

  def most_common_element(list) do
    {_amts, highest_count, highest_values} =
      Enum.reduce(list, {%{}, 0, []}, fn(v, {a, hc, hv}) ->
        case Map.update(a, v, 1, &(&1+1)) do
          %{^v => ^hc}=a -> {a, hc, [v | hv]}
          %{^v => c}=a when c>hc -> {a, c, [v]}
          a -> {a, hc, hv}
        end
      end)
    {highest_values, highest_count}
  end

  def solve1() do
    guards = Day4.read_and_parse
    |> Day4.group_guards

    {most_sleepy_one, minutes} = guards |> Day4.calculate_total_sleep
    |> Enum.sort(&(length(elem(&1, 1)) >= length(elem(&2, 1))))
    |> List.first

    {val, _} = Day4.most_common_element(minutes)
    IO.puts "Guard ID: #{most_sleepy_one} minute: #{Enum.at(val, 0)} answer to part 1: #{(most_sleepy_one |> String.to_integer) * Enum.at(val, 0) |> Kernel.round}}"
  end

  def solve2() do
    {guard_id, hour_with_most_sleep, _} = Day4.read_and_parse
    |> Day4.group_guards
    |> Day4.calculate_total_sleep
    |> Day4.best_sleep_minute
    |> List.keysort(2)
    |> Enum.reverse
    |> Enum.at(0)

    IO.puts "Guard ID: #{guard_id} minute: #{Enum.at(hour_with_most_sleep, 0)} answer to part 2: #{(guard_id |> String.to_integer) * Enum.at(hour_with_most_sleep, 0) |> Kernel.round}}"
  end
end

Day4.solve1()
Day4.solve2()
