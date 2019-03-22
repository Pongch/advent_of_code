defmodule SleepState do
  # keeps sleep state of each guard
  use Agent

  def start_sleeps() do
    {:ok, agent} = Agent.start_link fn -> %{} end
  end 

  def get_state(pid) do
    Agent.get(pid, &(&1))
  end

  def calculate_sleep(total_min, sleep_start_min, sleep_end_min) do
    total_min + (sleep_end_min - sleep_start_min)
  end

  def return_sleep_mins(sleep_start_min, sleep_end_min) do 
    sleep_start_min..sleep_end_min 
    |> Enum.map(fn x -> Integer.to_string(x) end)
  end

  def update_guard_sleeps(pid, current_guard, sleep_start_min, sleep_end_min) do
    current_state = get_state(pid)
    case Map.has_key?(current_state, current_guard)  do
      true -> 
        {_, new_state} = Map.get_and_update!(current_state, current_guard, fn {value, sleep_mins} ->
          {
            value, 
            { 
              calculate_sleep(value, sleep_start_min, sleep_end_min - 1),
              sleep_mins ++ return_sleep_mins(sleep_start_min, sleep_end_min - 1)
            }
          }
        end)
        Agent.update(pid, fn _ -> new_state end)
      false -> 
        new_state = Map.put(
          current_state, current_guard, 
          { 
            calculate_sleep(0, sleep_start_min, sleep_end_min - 1),
            return_sleep_mins(sleep_start_min, sleep_end_min - 1) 
          }
        )
        Agent.update(pid, fn _ -> new_state end)
    end
  end 
end