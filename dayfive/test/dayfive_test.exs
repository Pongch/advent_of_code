defmodule DayfiveTest do
  use ExUnit.Case
  doctest Dayfive

  test "should return the polarity for example" do
    assert Dayfive.part_one("sample.txt") == 10
  end

end
