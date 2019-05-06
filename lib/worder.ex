defmodule Worder do
  @moduledoc """
  Documentation for Worder.
  """

  @doc """
    Removes punctuation, line endings, and is case insensitive

    iex> Worder.cleanup("aaa bbb, ccc  \tddd... eee?")
    "aaa bbb ccc ddd eee"

    iex> Worder.cleanup("I love sandwiches.")
    "i love sandwiches"

    iex> Worder.cleanup("(I LOVE SANDWICHES!!)")
    "i love sandwiches"
  """

  def cleanup(text) do
    text
    |> String.replace(~r/[\p{P}\p{S}]/, "")
    |> String.replace(~r/\s+/, " ")
    |> String.downcase()
  end

  def main(args) do
    case args do
      [] -> IO.puts("stdio")
      files = [_ | _] -> IO.inspect(files)
    end
  end
end
