defmodule Dayone do
  @moduledoc """
  Dayone Challenge of Advent of Code

  """
  def part_one(file) do
    Dayone.parse(file)
    |> Enum.reduce 0, &(Dayone.do_count &1, &2)
  end

  def part_two(file) do
    Dayone.parse(file)
    |> Stream.cycle
    |> Enum.reduce %{sum: 0, repeat: MapSet.new([0])}, &(Dayone.do_count &1, &2) 
  end

  def do_count(value, sum) when is_integer(sum), do: String.to_integer(value) + sum 

  def do_count(value, %{sum: sum_amount, repeat: repeat_sums}) do 
    String.to_integer(value) + sum_amount |> Dayone.check_repeat(%{sum: sum_amount, repeat: repeat_sums})
  end

  def check_repeat(new_sum, %{sum: sum_amount, repeat: repeat_sums}) do
      case MapSet.member?(repeat_sums, new_sum) do 
        true -> throw({:return, new_sum})
        false -> %{sum: new_sum, repeat: MapSet.put(repeat_sums, new_sum)}
      end
  end

  def parse(file) when is_bitstring(file) do
    stream = File.stream! file
    fixed_contents = stream |> Enum.map(&String.trim/1)
  end
end
