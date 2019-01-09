defmodule DaythreeTest do
  use ExUnit.Case
  doctest Daythree

  test "should output the right square inches" do
    assert Daythree.part_one("input1.txt") == 4
  end
end
