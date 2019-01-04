defmodule DaytwoTest do
  use ExUnit.Case
  doctest Daytwo

  test "should output correct checksum" do
    assert Daytwo.part_one("input1.txt") == 12
  end

  test "should output correct checksum for the part_one answer" do
    assert Daytwo.part_one("input.txt") == 5976
  end
end
