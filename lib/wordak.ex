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
    Returns a map of most common three word sequences in the input, along
    with a count of how many times each occured.
  """
  def count(input) do
    input
    |> String.split(" ", trim: true)
    |> words()
    |> Enum.reduce(%{}, fn s, acc -> Map.update(acc, s, 1, &(&1 + 1)) end)
  end

  @doc """
    Returns a list of words sorted by descending occurance and in the
    alphabetical order
  """

  def sort(count) when is_map(count) do
    count
    |> Enum.to_list()
    |> Enum.sort(fn a, b ->
      [elem(a, 1), elem(b, 0)] <= [elem(b, 1), elem(a, 0)]
    end)
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

  def process(input) when is_binary(input) do
    input |> count()
  end

  def process(list) when is_list(list) do
    list
    |> Enum.map(&read_file(&1))
    |> Enum.map(&process(&1))
  end

  def combine(list) when is_list(list) do
    list
    |> List.flatten()
    |> Enum.map(&Map.to_list(&1))
    |> List.flatten()
    |> Enum.reduce(%{}, fn p, acc ->
      Map.update(acc, elem(p, 0), elem(p, 1), &(&1 + elem(p, 1)))
    end)
  end

  def output(result) when is_list(result) do
    result
    |> IO.inspect
    |> sort()
    |> Enum.take(100)
    |> IO.inspect(limit: :infinity)
  end

  defp read_stdio() do
    case IO.read(:stdio, :all) do
      :eof -> :ok
      text -> cleanup(text)
    end
  end

  defp read_file(filename) when is_binary(filename) do
    case File.read(filename) do
      {:ok, text} -> cleanup(text)
    end
  end

  def main(args) do
    case args do
      [] ->
        read_stdio()
        |> process()
        |> output()

      file_names = [_ | _] ->
        file_names
        |> process()
        |> output()
    end
  end
end
