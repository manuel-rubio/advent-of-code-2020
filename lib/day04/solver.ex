defmodule Advento.Day04.Solver do
  @filename "input04.txt"
  @required_fields ~w(byr iyr eyr hgt hcl ecl pid)

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(fn line ->
      fields =
        line
        |> String.split(~r/[\n\s]+/)
        |> Enum.filter(& &1 != "")

      for field <- fields, into: %{} do
        [key, value] = String.split(field, ":", parts: 2)
        {key, value}
      end
    end)
  end

  def solve(input, 1) do
    Enum.reduce(input, 0, fn passport, acc ->
      fields =
        passport
        |> Map.take(@required_fields)
        |> Map.keys()

      if @required_fields -- fields == [] do
        acc + 1
      else
        acc
      end
    end)
  end

  def solve(input, 2) do
    Enum.reduce(input, 0, fn passport, acc ->
      fields =
        passport
        |> Map.take(@required_fields)
        |> Map.keys()

      with true <- @required_fields -- fields == [],
           true <- Regex.match?(~r/^(19[2-9][0-9]|200[0-2])$/, passport["byr"]),
           true <- Regex.match?(~r/^20(1[0-9]|20)$/, passport["iyr"]),
           true <- Regex.match?(~r/^20(2[0-9]|30)$/, passport["eyr"]),
           true <- Regex.match?(~r/^(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)$/, passport["hgt"]),
           true <- Regex.match?(~r/^#[0-9a-f]{6}$/, passport["hcl"]),
           true <- passport["ecl"] in ~w(amb blu brn gry grn hzl oth),
           true <- Regex.match?(~r/^[0-9]{9}$/, passport["pid"]) do
        acc + 1
      else
        false -> acc
      end
    end)
  end

end
