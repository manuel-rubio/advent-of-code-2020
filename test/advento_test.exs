defmodule AdventoTest do
  use ExUnit.Case
  doctest Advento

  test "greets the world" do
    assert Advento.hello() == :world
  end
end
