defmodule Dayfour do
  @moduledoc """
  Documentation for Dayfour.
  """

  import SleepState

  #TODO sort
  def part_one(file) do
    File.stream!(file) 
    |> Enum.map(&String.trim/1) 
    |> sort_date()
    |> Enum.map(&line_output/1)
    |> Dayfour.compute_sleeps()
    |> Dayfour.total()
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

  def total(state) do
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

  #reduce the {current_guard_id},{begin_sleep_min, wake_min},[guard_id:{ total_sleep, [sleepMinutes]}] 
  #lets use Genserver/Agent
  #at wake-> push the sleep minutes and total_sleep into the reduce tuple
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
    SleepState.get_state(pid) |> IO.inspect
  end

  #finds the guard and return the guard_id * most recurring minute

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
