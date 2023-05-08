defmodule Advento.Day01.Solver do
  @filename "input01.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(& String.to_integer(&1))
  end

  def solve(input, num) do
    input
    |> Enum.filter(& &1 < 2020)
    |> find(num)
  end

  def find([], _num), do: "No solution!"
  def find([i | rest], 1) do
    if j = Enum.find(rest, & &1 == 2020 - i) do
      i * j
    else
      find(rest, 1)
    end
  end
  def find([i | rest], 2) do
    find(i, rest, 2) || find(rest, 2)
  end

  def find(_i, [], 2), do: nil
  def find(i, [j | rest], 2) do
    if k = Enum.find(rest, & &1 == 2020 - i - j) do
      i * j * k
    else
      find(i, rest, 2)
    end
  end
end
