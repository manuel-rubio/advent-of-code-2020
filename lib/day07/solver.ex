defmodule Advento.Day07.Solver do
  @filename "input07.txt"
  @initial_bag "shiny gold"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(fn line ->
      opts = [capture: :all_but_first]
      [main_bag, raw_bags] = Regex.run(~r/^((?: ?\w+){2}) bags? contain (.+)\.$/, line, opts)
      bags =
        raw_bags
        |> String.split(", ")
        |> Enum.map(fn bag ->
          Regex.run(~r/^(\d+) ((?: ?\w+){2}) bags?$/, bag, opts)
        end)
      {main_bag, bags}
    end)
    |> Map.new()
  end

  def solve(input, 1) do
    inverse =
      Enum.reduce(input, [], fn {key, values}, acc ->
        Enum.reduce(values, acc, fn
          [_, value], a -> [{value, key} | a]
          nil, a -> a
        end)
      end)

    bags =
      inverse
      |> search(@initial_bag, [])
      |> Enum.sort()
      |> Enum.uniq()

    Enum.count(bags -- [@initial_bag])
  end

  def solve(input, 2) do
    rules =
      for {main_bag, bags} <- input, into: %{} do
        {main_bag, for [n, bag] <- bags do
          {String.to_integer(n), bag}
        end}
      end

    counting(rules, {1, @initial_bag}, 0, 1) - 1
  end

  defp counting(inverse, {n, bag}, acc, idx) do
    inverse
    |> Enum.filter(fn {key, _} -> key == bag end)
    |> Enum.map(fn {_, values} -> values end)
    |> Enum.reduce(acc + idx * n, fn values, acc0 ->
      Enum.reduce(values, acc0, &counting(inverse, &1, &2, idx * n))
    end)
  end

  defp search(inverse, bag, bags) do
    inverse
    |> Enum.filter(fn {key, _} -> key == bag end)
    |> Enum.map(fn {_, values} -> values end)
    |> Enum.reduce([bag | bags], &search(inverse, &1, &2))
  end
end
