defmodule DaythreeTest do
  use ExUnit.Case
  doctest Daythree

  test "should output the right square inches for test input" do
    assert Daythree.part_one("input1.txt") == 4
  end

  test "should output the right square inches for real input" do
    assert Daythree.part_one("input.txt") == 97218
  end

  test "should find unique claim for test input" do
    assert Daythree.part_two("input1.txt") == 3
  end

  test "should find the unique claim" do
    assert Daythree.part_two("input.txt") == 717
  end
end
