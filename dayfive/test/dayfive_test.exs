defmodule DayfiveTest do
  use ExUnit.Case
  doctest Dayfive

  # test "should return the polarity for example" do
  #   assert Dayfive.react("sample.txt") == 10
  # end

  test "should return :ok if 2 units are right polymer pair" do
    assert Dayfive.valid_polymer_pair("a","A") == {:ok}
    assert Dayfive.valid_polymer_pair("A","a") == {:ok}
    assert Dayfive.valid_polymer_pair("A","c") == {:error}
  end
end
