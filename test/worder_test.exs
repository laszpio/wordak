defmodule WorderTest do
  use ExUnit.Case
  doctest Worder

  test "greets the world" do
    assert Worder.hello() == :world
  end
end
