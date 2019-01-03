defmodule DayoneTest do
  use ExUnit.Case
  doctest Dayone

  test "should output correct value for part one" do
    assert Dayone.part_one("input.txt") == 466
  end

  test "should output correct value for part two (input1.txt)" do
    assert catch_throw(Dayone.part_two("input1.txt")) == {:return, 2}
  end

  test "should output correct value for part two (input2.txt)" do
    assert catch_throw(Dayone.part_two("input2.txt")) == {:return, 0}
  end

  test "should output correct value for part two (input3.txt)" do
    assert catch_throw(Dayone.part_two("input3.txt")) == {:return, 10}
  end

  test "should output correct value for part two (input4.txt)" do
    assert catch_throw(Dayone.part_two("input4.txt")) == {:return, 5}
  end

  test "should output correct value for part two (input5.txt)" do
    assert catch_throw(Dayone.part_two("input5.txt")) == {:return, 14}
  end

  test "should output correct value for part two (input.txt)" do
    assert catch_throw(Dayone.part_two("input.txt")) == {:return, 750}
  end
end
