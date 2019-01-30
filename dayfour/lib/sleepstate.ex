defmodule SleepState do
  use Agent

  def start_sleeps() do
    {:ok, agent} = Agent.start_link fn -> %{} end
  end 

  def get_state(pid) do
    Agent.get(pid, &(&1))
  end

  #TODO compute the sleeps
  def update_guard_sleeps(pid, current_guard, sleep_start_min, sleep_end_min) do
    IO.puts(pid, current_guard, sleep_start_min, sleep_end_min)
    #Agent.update(pid, fn _ -> new_state end)
  end 

  

end