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

  def part_two(file) do
    parse(file)
    |> Enum.map(&(Daythree.split_val &1))
    |> Enum.map(fn [id, left, top, width, length] -> 
      {id, Daythree.get_coord([id, left, top, width, length]) |> MapSet.new()}
    end)
    |> Daythree.get_unique_id
  end 

  def get_unique_id(id_to_coords) do
    Enum.reduce_while(id_to_coords, 0, fn {k,v}, acc ->  
      case Daythree.do_get_uniq({k,v}, id_to_coords) do
        {:not_found} -> {:cont, acc}
        {:found, found_id} -> {:halt, found_id}
      end
    end)
  end

  def do_get_uniq({id, value}, rest) do
    intersection_number = Enum.reduce(rest, 0, fn {k,v}, matches -> 
      if MapSet.intersection(value, v) == MapSet.new([]), do: matches, else: matches + 1
    end)
    case intersection_number do
      1 -> {:found, id}
      _ -> {:not_found}
    end
  end

  def get_coord([_,left, top, width, length]) do
    {start_left, start_top} = {(left + 1), (top + 1)}
    Enum.reduce(0..width - 1, [], fn w, acc ->
      width_values = Enum.reduce(0..length - 1, [], fn l, acc -> 
        [{w + start_left, l + start_top} | acc]
      end)
      [width_values | acc]
    end) 
    |> List.flatten
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

  def split_val(string) do
    [_, id, left, top, width, length] = String.split(string,["#"," @ ",",",": ","x"])
    Enum.map([id, left, top, width, length], &String.to_integer/1)
  end

  def parse(file) do
    File.stream!(file) |> Enum.map(&String.trim/1)
  end
end
