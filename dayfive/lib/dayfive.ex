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
    |> scan()
    |> react()
  end

  # running scanning and reacting the polymer until no
  def run_loop() do
  end

  # start going through list from head, returns the first valid match and the current list
  def scan(res) do
    {first_match, index} = Enum.reduce_while(res, {nil, nil, 0}, fn value, {last_value, last_valid_polymers, index} = acc -> 
      case valid_polymer_pair(value, acc) do
        #if last_value is still nil, do nothing- sets last value to current
        {:error, :nil_val} -> {:cont, {value, last_valid_polymers, index + 1}}
        #if last_value is not nil, check if value and last_val is a valid_polymer_pair, if no sets last val to current, 
        {:error, :not_matched} -> {:cont, {value, last_valid_polymers, index + 1}}
        # if ok, check the next closest value
        {:ok } -> {:cont, {value, [last_value, value], index + 1}}
        {:ok, :keep_going} -> {:cont, {value, last_valid_polymers ++ [value], index + 1}}
        {:ok, :stop} -> {:halt, {last_valid_polymers, index - 1}}
      end
    end)
    #returns res and first polymer_match
    {res, length(first_match), index}
  end

  def react({list, 0, index}), do: {:ok, list} 

  def react({list, units, index}) do
    new_list = List.delete_at(list, index)
    react({new_list, units - 1, index - 1})
  end
  

  def valid_polymer_pair(unit1, {nil, nil, 0}), do: {:error, :nil_val}

  # validate first pair
  def valid_polymer_pair(unit_1, {unit_2, nil, _}) do
    <<val1::utf8>> = unit_1
    <<val2::utf8>> = unit_2
    case val1 - val2 do 
      32 -> {:ok}
      - 32 -> {:ok}
      _ -> {:error, :not_matched}
    end
  end

  # validate already matched pair with next value
  def valid_polymer_pair(unit_1, {unit_2, prev_match, _}) do
    <<val1::utf8>> = unit_1
    <<val2::utf8>> = unit_2
    case val1 - val2 do 
      32 -> {:ok, :keep_going}
      - 32 -> {:ok, :keep_going}
      _ -> {:ok, :stop} # done, the prev match is last valid match
    end
  end

  # returns a list of graphemes
  def parse(file) do
    [res] = File.stream!(file) |> Enum.map(&String.graphemes/1)
    res
  end
end
