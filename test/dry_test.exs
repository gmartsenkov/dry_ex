defmodule DryTest do
  use ExUnit.Case
  doctest Dry

  test "greets the world" do
    assert Dry.hello() == :world
  end
end
