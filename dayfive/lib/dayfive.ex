defmodule Dayfive do
  @moduledoc """
  Documentation for Dayfive.

  Main run_loop:
  1/ scan through to find the first pair in list
    1.2/ if is a pair that is polymer pair, check the next letter, if next letter is not polymer- REACT
    1.3/ start from the head of the list again
    1.4/ if no more pair in list- return the final list
  """

  def part_one(file) do
    parse(file)
    |> run_loop
    |> Enum.count()
  end

  # running scanning and reacting the polymer until no
  def run_loop({:ok, list}) do
    scan(list) |> react() |> run_loop()
  end

  def run_loop({:ok, :done, list}), do: list 
  
  def run_loop(list) do
    scan(list) |> react() |> run_loop()
  end

  def check_result({first_match, index}), do: {first_match, index}

  def check_result({_,_,_}), do: {[], nil} 

  # start going through list from head, returns the first valid match and the current list
  def scan(res) do
    scanned_result = Enum.reduce_while(res, {nil, nil, 0}, fn value, {last_value, last_valid_polymers, index} = acc -> 
      
      case valid_polymer_pair(value, acc) do
        #if last_value is still nil, do nothing- sets last value to current
        {:error, :nil_val} -> {:cont, {value, last_valid_polymers, index + 1}}
        #if last_value is not nil, check if value and last_val is a valid_polymer_pair, if no sets last val to current, 
        {:ok, :keep_going} -> {:cont, {value, last_valid_polymers, index + 1}}

        {:ok} -> {:halt, {[last_value, value], index - 1}}
      end
    end)
    {first_match, index} = check_result(scanned_result)
    #returns res and first polymer_match
    {res, length(first_match), index}
  end

  def valid_polymer_pair(unit1, {nil, nil, 0}), do: {:error, :nil_val}

  # validate first pair
  def valid_polymer_pair(unit_1, {unit_2, nil, _}) do
    <<val1::utf8>> = unit_1
    <<val2::utf8>> = unit_2
    case val1 - val2 do 
      32 -> {:ok}
      - 32 -> {:ok}
      _ -> {:ok, :keep_going}
    end
  end

  def react({list, 0, nil}), do: {:ok, :done, list}

  def react({list, 0, index}) do
   {:ok, list} 
  end

  def react({list, units, index}) do
    new_list = List.delete_at(list, index)
    react({new_list, units - 1, index})
  end

  # returns a list of graphemes
  def parse(file) do
    [res] = File.stream!(file) |> Enum.map(&String.graphemes/1)
    res
  end
end
