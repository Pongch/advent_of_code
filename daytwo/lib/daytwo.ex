defmodule Daytwo do
  @moduledoc """
  Documentation for Daytwo.
  """
  
  def part_one(file) do
    Daytwo.parse(file)
    |> Enum.reduce(%{accu_twice: 0, accu_thrice: 0 }, &(Daytwo.scan_string &1, &2))
    |> Daytwo.calculate()
  end

  def part_two(file) do
    Daytwo.parse(file)
    |> Daytwo.find_box
  end

  def find_box(strings) do
    {box_one, box_two} = Enum.reduce_while(strings, [], fn x, acc -> 
      box_found = do_find_box(x, acc)
      case box_found do
        nil -> {:cont, [x | acc]}
        found -> {:halt, {found, x}}
      end
    end)
    String.myers_difference(box_one, box_two) |> Keyword.get_values(:eq) |> Enum.join
    
  end

  def do_find_box(line, accu) do
    found = Enum.find(accu, fn x -> 
        filtered = String.myers_difference(line, x) 
        length(filtered) == 4 
    end)
  end


  def calculate(%{accu_twice: counted_twice, accu_thrice: counted_thrice}) do
    counted_thrice * counted_twice
  end

  def scan_string(string, accu) do
    scanned = String.graphemes(string) 
    |> Enum.reduce(%{once: [], twice: [], thrice: []}, 
    fn char, %{once: once_map, twice: twice_map, thrice: thrice_map} -> 
      cond do
        Enum.member?(once_map, char) ->
          %{once: List.delete(once_map, char), twice: [char | twice_map], thrice: thrice_map}
        Enum.member?(twice_map, char) ->
          %{once: once_map, twice: List.delete(twice_map, char), thrice: [char | thrice_map]}
        true ->
          %{once: [char | once_map], twice: twice_map, thrice: thrice_map}
      end 
    end)
  
    Daytwo.sum(scanned, accu)
  end
  
  def sum(%{once: _, twice: twice_map, thrice: thrice_map}, %{accu_twice: twice_val, accu_thrice: thrice_val}) do
    twice = Enum.count(twice_map)
    thrice = Enum.count(thrice_map)
    
    cond do
      twice === 0 && thrice === 0 -> %{accu_twice: twice_val, accu_thrice: thrice_val}
      twice >= 1 && thrice === 0 -> %{accu_twice: twice_val + 1, accu_thrice: thrice_val}
      twice === 0 && thrice >= 1 -> %{accu_twice: twice_val, accu_thrice: thrice_val + 1}
      twice >= 1 && thrice >= 1 -> %{accu_twice: twice_val + 1, accu_thrice: thrice_val + 1}
    end
  end

  def parse(file) do
    File.stream!(file) |> Enum.map(&String.trim/1) 
  end

end
