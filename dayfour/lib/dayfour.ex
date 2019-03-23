defmodule Dayfour do
  import SleepState

  def part_one(file), do: get_sleep(file)|> Dayfour.run_part_one()

  def part_two(file), do: get_sleep(file) |> Dayfour.run_part_two()

  def get_sleep(file) do
    File.stream!(file)
    |> Enum.map(&String.trim/1) 
    |> sort_date()
    |> Enum.map(&line_output/1)
    |> Dayfour.compute_sleeps()
  end 

  def run_part_two(sleep_map) do
    {guard_id, min, _} = sleep_map
    |> Map.to_list()
    |> Enum.map(&do_count_sleep_mins/1)
    |> Enum.map(&get_most_sleep_mins/1)
    |> Enum.reduce({nil, 0, 0}, fn [guard_id, {sleep_min, sleep_count}], {biggest_guard, biggest_min, biggest_count} -> 
      cond do
        sleep_count > biggest_count ->
          {guard_id, sleep_min, sleep_count}
        true ->
          {biggest_guard, biggest_min, biggest_count}
      end
    end)
    guard_id * String.to_integer(min)
  end

  def get_most_sleep_mins([guard_id, mins]) do    
    res = Enum.reduce(mins, {"nil", 0}, fn {min, count}, {biggest_min, biggest_count}-> 
      cond do
        count > biggest_count ->
          {min, count}
        true ->
          {biggest_min, biggest_count}
      end
    end)
    [guard_id, res]
  end

  def do_count_sleep_mins({guard_id, {_, sleepmins}}) do
    sleep_counts = sleepmins
    |> Enum.uniq()
    |> Enum.map(fn min -> 
      {min, Enum.count(sleepmins, fn x -> x == min end)}
    end)
    [guard_id, sleep_counts]
  end 

  # takes list of strings
  defp sort_date(file) do
    file
    |> Enum.map(fn string -> 
      {string, get_index(string)}
    end)
    |> Enum.sort_by(fn {_, [month, day, hour, min]} -> {month, day, hour, min} end)
    |> Enum.map(fn {string, _} -> string end)
  end

  def get_index(string) do
    [_, month, day, hour, min, _] = String.split(string, ["[1518-", "-", " " ,":" ,"]"], parts: 6) 
    [month, day, hour, min] |> Enum.map(&(String.to_integer(&1)))
  end

  defp id_times_min({id, min, mins}) do
    [key] = Dayfour.get_minute(mins)
    String.to_integer(key) * id
  end

  def get_minute(mins) do
    gb = Enum.group_by(mins, &(&1))
    max = Enum.map(gb, fn {_,val} -> length(val) end) |> Enum.max
    for {key,val} <- gb, length(val)==max, do: key
  end

  @spec run_part_one(map) :: integer
  def run_part_one(state) do
    state
    |> Map.to_list()
    |> Enum.reduce({0, 0, []}, fn {id, {val, mins}}, {total_id, total_val, total_mins} -> 
      cond do
        total_val < val -> 
          {id, val, mins}
        true ->
          {total_id, total_val, total_mins}
      end
    end)
    |> id_times_min()
  end

  @spec compute_sleeps(list) :: map
  def compute_sleeps(sleeps) do
    {_, pid} = SleepState.start_sleeps()

    Enum.reduce(sleeps, {nil, nil, nil}, fn {action, value}, {current_guard, sleep_start_min, sleep_stop_min} -> 
      case action do
        :new_guard ->
          # resets 
          {value, nil, nil}
        :begin_sleeps -> 
          {current_guard, value, sleep_stop_min}
        :begin_wakes -> 
          SleepState.update_guard_sleeps(pid, current_guard, sleep_start_min, value)
          {current_guard, sleep_start_min, value}
      end
    end)
    SleepState.get_state(pid) 
  end

  @spec line_output(charlist) :: tuple
  def line_output(string) do
    data = String.contains?(string, ["Guard", "#"])
    case data do
      true -> return_match(string, :guard)
      false -> return_match(string, :sleep_stat)
    end
  end

  @spec return_match(charlist, atom) :: tuple
  def return_match(string, :guard) do
    with [_, _, _, start_guard_id, _] <- String.split(string, [":", "]","#", " b"]) 
    do
      {:new_guard, String.to_integer(start_guard_id)}
    end
  end

  @spec return_match(charlist, atom) :: tuple
  def return_match(string, :sleep_stat) do
    with [_, minute, stat] <- String.split(string, [":", "]"]) 
    do 
      case stat do
        " wakes up" -> {:begin_wakes, String.to_integer(minute)}
        " falls asleep" -> {:begin_sleeps, String.to_integer(minute)}
      end
    end
  end

end
