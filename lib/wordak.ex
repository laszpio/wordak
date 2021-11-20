defmodule Wordak do
  @moduledoc """
    Documentation for Wordak.
  """

  @doc """
    Returns a list of n-words sequences
  """
  def words(list, n) when is_list(list) and length(list) <= n - 2, do: []

  def words(list, n), do: is_list(list) and words(list, n, [])

  defp words(list, n, acc) when length(list) == n - 1, do: acc

  defp words([current | rest], n, acc) when length(rest) > n - 2 do
    new = [current | Enum.take(rest, n - 1)] |> Enum.join(" ")
    words(rest, n, [new | acc])
  end

  @doc """
    Returns a map of most common n-word sequences in the input, along
    with a count of how many times each occured.
  """
  def count(input, n) do
    input
    |> String.split(" ", trim: true)
    |> words(n)
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
    |> String.replace(~r/(*UTF8)[\x{200B}\x{200C}\x{200D}\x{FEFF}]/u, "")
    |> String.replace(~r/[\p{P}\p{S}]/, "")
    |> String.replace(~r/\s+/, " ")
    |> String.downcase()
  end

  @doc """
    Processes string or files into count of n-words sequences
  """
  def process(input, n) when is_binary(input) do
    input |> count(n)
  end

  def process(list, n) when is_list(list) do
    list
    |> Enum.map(&read_file(&1))
    |> Enum.map(&process(&1, n))
  end

  @doc """
    Combines list of counts of n-words seqeunces into single one
  """
  def combine(list) when is_list(list) do
    list
    |> List.flatten()
    |> Enum.reduce(%{}, fn m, acc ->
      Map.merge(acc, m, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  @doc """
    Formats n-words sequences
  """
  def output(result, limit \\ 100) when is_map(result) do
    result
    |> sort()
    |> Enum.take(limit)
    |> Enum.each(fn {words, count} = _ -> IO.puts("#{words}: #{count}") end)
  end

  defp read_stdio do
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
    {opts, word, _} = OptionParser.parse(args, strict: [sequence: :integer])

    sequence_length = Keyword.get(opts, :sequence, 3)

    case word do
      [] ->
        read_stdio()
        |> process(sequence_length)
        |> output()

      file_names = [_ | _] ->
        file_names
        |> process(sequence_length)
        |> combine()
        |> output()
    end
  end
end
