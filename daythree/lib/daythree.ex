defmodule Daythree do
  @moduledoc """
  
  """
  def part_one(file) do
    parse(file)
    |> Enum.map(&(Daythree.split_val &1))
    |> Enum.map(&(Daythree.get_coord &1))
    |> List.flatten
    |> Daythree.find_dup
  end
  
  def find_dup(list) do
    {matched, _} = Enum.reduce(list, {MapSet.new(), MapSet.new()}, fn {x, y}, {matched, unmatched} ->
        if MapSet.member?(unmatched, {x, y}) do
          if MapSet.member?(matched, {x, y}), do: {matched, unmatched}, else: {MapSet.put(matched, {x, y}), unmatched}
        else
          {matched, MapSet.put(unmatched, {x, y})}
        end
    end)
    MapSet.size(matched)
  end

  def get_coord({left, top, width, length}) do
    {start_left, start_top} = {(left + 1), (top + 1)}
    Enum.reduce(0..width - 1, [], fn w, acc ->
      width_values = Enum.reduce(0..length - 1, [], fn l, acc -> 
        [{w + start_left, l + start_top} | acc]
      end)
      [width_values | acc]
    end) 
    |> List.flatten
  end 

  def split_val(string) do
    [string, start] = String.split(string, ": ") 
    Daythree.split_val(string, start) 
  end
  
  def split_val(string, area) do
    [string, start] = String.split(string, "@ ")
    [left, top] = String.split(start, ",")
    [width, length] = String.split(area, "x")
    {String.to_integer(left),String.to_integer(top),String.to_integer(width), String.to_integer(length)}
  end

  def parse(file) do
    File.stream!(file) |> Enum.map(&String.trim/1)
  end
end
