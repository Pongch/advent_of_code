defmodule Daythree do
  @moduledoc """
  
  """
  def part_one(file) do
    parse(file)
    |> Enum.map(&(Daythree.split_val &1))
  end

  def split_val(string) do
   [string, start] = String.split(string, ": ") 
   Daythree.split_val(string, start) 
  end
  
  def split_val(string, area) do
    [string, start] = String.split(string, "@ ")
    {start, area} 
  end

  def parse(file) do
    File.stream!(file) |> Enum.map(&String.trim/1)
  end
end
