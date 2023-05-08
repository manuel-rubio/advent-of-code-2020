defmodule Advento.Day02.Solver do
  @filename "input02.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(& Regex.run(~r/^([0-9]+)-([0-9]+) ([a-z]): (.+)$/, &1))
    |> Enum.map(fn [_ , min, max, letter, password] ->
      password = String.graphemes(password)
      [String.to_integer(min), String.to_integer(max), letter, password]
    end)
  end

  def solve(input, 1) do
    Enum.reduce(input, 0, fn [min, max, letter, password], acc ->
      freq_letter = Enum.frequencies(password)[letter]
      if freq_letter >= min and freq_letter <= max do
        acc + 1
      else
        acc
      end
    end)
  end
  def solve(input, 2) do
    Enum.reduce(input, 0, fn [pos1, pos2, letter, password], acc ->
      c1 = Enum.at(password, pos1 - 1) == letter
      c2 = Enum.at(password, pos2 - 1) == letter
      if (c1 and not c2) or (c2 and not c1) do
        acc + 1
      else
        acc
      end
    end)
  end
end
