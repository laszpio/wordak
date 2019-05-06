defmodule WorderTest do
  use ExUnit.Case
  doctest Worder

  import Worder

  describe ".cleanup" do
    assert cleanup("\uFEFFThe") == "the"

    assert cleanup("aaa, bbb? ccc.") == "aaa bbb ccc"
    assert cleanup("aaa,  bbb, ccc") == "aaa bbb ccc"

    assert cleanup("I love\nsandwiches.") == "i love sandwiches"
    assert cleanup("(I LOVE SANDWICHES!!)") == "i love sandwiches"

    assert cleanup("M.A.") == "ma"
  end
end
