defmodule Worder do
  @moduledoc """
  Documentation for Worder.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Worder.hello()
      :world

  """
  def hello do
    :world
  end

  def main(args) do
    case args do
      [] -> IO.puts "stdio"
      files = [_|_] -> IO.inspect files
    end
  end
end
