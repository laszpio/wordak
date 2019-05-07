defmodule Worder do
  @moduledoc """
  Documentation for Worder.
  """

  def words([]), do: []

  def words(list), do: words(list, [])

  def words([current | rest], acc) do
    if length(rest) > 1 do
      new = [current | Enum.take(rest, 2)] |> Enum.join(" ")
      words(rest, [new | acc])
    else
      acc
    end
  end

  def count(input) do
    input
    |> String.split()
    |> words()
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  @doc """
   Removes punctuation, line endings, and is case insensitive
  """

  def cleanup(text) do
    text
    |> String.replace(~r/[\x{200B}\x{200C}\x{200D}\x{FEFF}]/u, "")
    |> String.replace(~r/[\p{P}\p{S}]/, "")
    |> String.replace(~r/\r|\n/, " ")
    |> String.replace(~r/\s+/, " ")
    |> String.downcase()
    |> String.trim()
  end

  def read() do
    case IO.read(:stdio, :all) do
      :eof -> :ok
      text -> cleanup(text)
    end
  end

  def main(args) do
    case args do
      [] -> read() |> count()
      files = [_ | _] -> IO.inspect(files)
    end
  end
end
