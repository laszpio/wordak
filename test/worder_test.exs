defmodule WorderTest do
  use ExUnit.Case
  doctest Worder

  import Worder

  describe ".cleanup" do
    test "remove zero-length character" do
      assert cleanup("\uFEFFThe") == "the"
    end

    test "ignores punctuation" do
      assert cleanup("aaa, bbb? ccc.") == "aaa bbb ccc"
      assert cleanup("aaa,  bbb, ccc") == "aaa bbb ccc"
    end

    test "new lines" do
      assert cleanup("I love\nsandwiches.") == "i love sandwiches"
    end

    test "case insensitive" do
      assert cleanup("(I LOVE SANDWICHES!!)") == "i love sandwiches"
    end

    test "abbreviations" do
      assert cleanup("M.A.") == "ma"
    end
  end

  describe ".count()" do
    assert count("a b c d e f") == %{
             "a b c" => 1,
             "b c d" => 1,
             "c d e" => 1,
             "d e f" => 1
    }

    assert count("a b c a b c a") == %{
      "a b c" => 2,
      "b c a" => 2,
      "c a b" => 1
    }
  end
end
