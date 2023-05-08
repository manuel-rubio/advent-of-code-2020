defmodule Advento.Day09.Solver do
  @filename "input09.txt"
  @preamble 25

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(&String.to_integer/1)
  end

  def solve(input, 1) do
    {preamble, to_process} = Enum.split(input, @preamble)
    find(preamble, to_process)
  end

  def solve(input, 2) do
    n = solve(input, 1)
    find_sum(input, n)
  end

  defp find_sum([_ | ns] = input, number) do
    if sum = find_sum(input, 0, [], number) do
      sum
    else
      find_sum(ns, number)
    end
  end

  defp find_sum([], _sum, _set, _number), do: nil
  defp find_sum([n1 | ns], sum, set, number) do
    cond do
      n1 + sum == number ->
        {min, max} = Enum.min_max([n1 | set])
        min + max
      n1 + sum > number ->
        nil
      true ->
        find_sum(ns, sum + n1, [n1 | set], number)
    end
  end

  defp find(_preamble, []), do: nil
  defp find(preamble, [n1 | ns]) do
    if exists_sum?(preamble, n1) do
      find(Enum.slice(preamble, 1..@preamble) ++ [n1], ns)
    else
      n1
    end
  end

  defp exists_sum?([], _number), do: false
  defp exists_sum?([n1 | ns], number) do
    if Enum.any?(ns, & &1 + n1 == number) do
      true
    else
      exists_sum?(ns, number)
    end
  end
end
