defmodule Wordak do
  @moduledoc """
    Documentation for Wordak.
  """

  def words([]), do: []

  def words(list), do: words(list, [])

  def words(list, acc) when length(list) == 2, do: acc

  def words([current | rest], acc) when length(rest) > 1 do
    new = [current | Enum.take(rest, 2)] |> Enum.join(" ")
    words(rest, [new | acc])
  end

  @doc """
    Returns a list of most common three word sequences in the input, along
    with a count of how many times each occured.
  """
  def count(input) do
    input
    |> String.split(" ", trim: true)
    |> words()
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Map.to_list()
  end

  @doc """
    Returns a list of words sorted by descending occurance and in the
    alphabetical order
  """

  def sort(list) when is_list(list) do
    list
    |> Enum.sort(fn a, b -> [elem(a, 1), elem(b, 0)] <= [elem(b, 1), elem(a, 0)] end)
    |> Enum.reverse()
  end

  @doc """
   Removes punctuation, line endings, and is case insensitive.
  """

  def cleanup(text) do
    text
    |> String.replace(~r/[\x{200B}\x{200C}\x{200D}\x{FEFF}]/u, "")
    |> String.replace(~r/[\p{P}\p{S}]/, "")
    |> String.replace(~r/\s+/, " ")
    |> String.downcase()
  end

  defp read_stdio() do
    case IO.read(:stdio, :all) do
      :eof -> :ok
      text -> cleanup(text)
    end
  end

  def main(args) do
    case args do
      [] -> read_stdio() |> count() |> sort() |> IO.inspect()
      files = [_ | _] -> IO.inspect(files)
    end
  end
end
