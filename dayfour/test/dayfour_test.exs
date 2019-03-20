defmodule DayfourTest do
  use ExUnit.Case
  doctest Dayfour

  @tag :skip
  test "should output the guard id * minutes for test data" do
    assert Dayfour.guard_id_time_minutes("sleep_data_1.txt") == 240
  end

  test "should return guard_status, guard ID and minute" do
    assert Dayfour.line_output("[1518-11-02 00:40] falls asleep") == {:begin_sleeps, 40}
    assert Dayfour.line_output("[1518-11-02 00:50] wakes up") == {:begin_wakes, 50}
  end

  test "should return status, and minute" do
    assert Dayfour.line_output("[1518-11-03 00:05] Guard #10 begins shift") == {:new_guard,10}
  end 

  test "should return the answer for small sample" do
    assert Dayfour.part_one("sleep_1.txt") == 240
  end 

  test "should return the answer for real sample" do
    assert Dayfour.part_one("sleep_2.txt") == 39698
  end 
end
