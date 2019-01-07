defmodule DaytwoTest do
  use ExUnit.Case
  doctest Daytwo

  test "should output correct checksum" do
    assert Daytwo.part_one("input1.txt") == 12
  end

  test "should output correct checksum for the part_one answer" do
    assert Daytwo.part_one("input.txt") == 5976
  end
  
  test "should find the right box" do
    assert Daytwo.part_two("input2.txt") == "fgij"
  end

  test "should find the right box for part_two" do
    assert Daytwo.part_two("input.txt") == "xretqmmonskvzupalfiwhcfdb"
  end
end
