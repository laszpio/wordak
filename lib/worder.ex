defmodule Worder do
  @moduledoc """
  Documentation for Worder.
  """

  def count(input) do
    input
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
      [] -> read()
      files = [_ | _] -> IO.inspect(files)
    end
  end
end
