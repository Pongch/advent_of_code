defmodule Dayfour do
  @moduledoc """
  Documentation for Dayfour.

  [{guard_no: int, total_sleep, sleep_minutes:[1,2,3,4...]},... ]

  [1518-11-01 00:55] wakes up
  [1518-11-01 23:58] Guard #99 begins shift
  [1518-11-02 00:40] falls asleep

  status: :begin_sleeps, :wakes_up

  (previousstate, currentstate) 
  if begin_sleeps -> wakes_up, do add_sleep_minutes_and_total_sleeps_to_guard_id
  elseif wakes_up -> begins_sleep do nil

  must sort data by date first
  """

  import SleepState

  def guard_id_time_minutes() do
    File.stream!("sleep_1.txt") 
    |> Enum.map(&String.trim/1) 
    |> Enum.map(&Dayfour.line_output/1)
    |> Dayfour.compute_sleeps()
  end


  #reduce the {current_guard_id},{begin_sleep_min, wake_min},[guard_id:{ total_sleep, [sleepMinutes]}] 
  #lets use Genserver/Agent
  #at wake-> push the sleep minutes and total_sleep into the reduce tuple
  def compute_sleeps(sleeps) do
    {_, pid} = SleepState.start_sleeps()

    Enum.reduce(sleeps, {"","",""}, fn {action, value}, {current_guard, sleep_start_min, sleep_stop_min} -> 
      case action do
        :new_guard -> 
          {value, "", ""}
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
