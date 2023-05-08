defmodule Advento.Day06.Solver do
  @filename "input06.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(fn line ->
      line
      |> String.split("\n")
      |> Enum.filter(& &1 != "")
      |> Enum.map(&String.graphemes/1)
    end)
  end

  def solve(input, 1) do
    input
    |> Enum.map(fn line ->
      line
      |> List.flatten()
      |> MapSet.new()
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  def solve(input, 2) do
    input
    |> Enum.map(fn group ->
      group
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(nil, &intersection/2)
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  defp intersection(set, nil), do: set
  defp intersection(set1, set2), do: MapSet.intersection(set1, set2)
end
