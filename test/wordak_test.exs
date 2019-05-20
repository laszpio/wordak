defmodule WordakTest do
  use ExUnit.Case
  doctest Wordak

  import Wordak

  @seq_length 3

  describe ".words" do
    test "empty input list" do
      assert words([], @seq_length) == []
      assert words(["aa"], @seq_length) == []
      assert words(["aa", "bb"], @seq_length) == []
      assert words(["aa", "bb", "cc"], @seq_length) == ["aa bb cc"]
    end

    test "creates list of 3 words sequences" do
      words = words(["aa", "bb", "cc", "dd", "ee"], @seq_length)

      assert length(words) == 3
      assert Enum.member?(words, "aa bb cc")
      assert Enum.member?(words, "bb cc dd")
      assert Enum.member?(words, "cc dd ee")
    end

    test "creates list of 2 words sequences" do
      words = words(["aa", "bb", "cc", "dd", "ee"], 2)

      assert length(words) == 4
      assert Enum.member?(words, "aa bb")
      assert Enum.member?(words, "bb cc")
      assert Enum.member?(words, "cc dd")
      assert Enum.member?(words, "dd ee")
    end
  end

  describe ".cleanup" do
    test "removes zero-length character" do
      assert cleanup("\uFEFFThe") == "the"
    end

    test "ignores punctuation" do
      assert cleanup("aaa, bbb? ccc.") == "aaa bbb ccc"
      assert cleanup("aaa,  bbb, ccc") == "aaa bbb ccc"
    end

    test "spacial chars" do
      assert cleanup("!@#$%^&*(){}[]:;'/?><,.~`-_+=|word") == "word"
    end

    test "new lines" do
      assert cleanup("I love\nsandwiches.") == "i love sandwiches"
      assert cleanup("I love\n\rsandwiches.") == "i love sandwiches"
    end

    test "tabulations and extra whitespaces" do
      assert cleanup("I   love\t\t\tsandwiches.") == "i love sandwiches"
    end

    test "case insensitive" do
      assert cleanup("(I LOVE SANDWICHES!!)") == "i love sandwiches"
    end

    test "abbreviations" do
      assert cleanup("M.A.") == "ma"
    end

    test "quotes" do
      assert cleanup("is it \"WORD\"?") == "is it word"
      assert cleanup("is it \'WORD\'?") == "is it word"
    end
  end

  describe ".count" do
    assert count("a b c d e f", @seq_length) == %{
             "a b c" => 1,
             "b c d" => 1,
             "c d e" => 1,
             "d e f" => 1
           }

    assert count("a b c a b c a", @seq_length) == %{
             "a b c" => 2,
             "b c a" => 2,
             "c a b" => 1
           }
  end

  describe ".sort" do
    assert %{"b c a" => 2, "a b c" => 2, "c a b" => 1} |> sort() == [
             {"a b c", 2},
             {"b c a", 2},
             {"c a b", 1}
           ]

    assert %{"c a" => 1, "c b" => 1, "x x" => 2, "c c" => 1} |> sort() == [
             {"x x", 2},
             {"c a", 1},
             {"c b", 1},
             {"c c", 1}
           ]
  end

  describe ".combine" do
    test "empty" do
      assert combine([]) == %{}
    end

    test "combines 2 results" do
      assert combine([
               [%{"a a a" => 1, "b b b" => 2, "c c c" => 1}],
               [%{"a a a" => 1, "c c c" => 2, "d d d" => 1}]
             ]) == %{
               "a a a" => 2,
               "b b b" => 2,
               "c c c" => 3,
               "d d d" => 1
             }
    end
  end
end
