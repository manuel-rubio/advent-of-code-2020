defmodule Advento.Day10.Solver do
  @filename "input10.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(&String.to_integer/1)
  end

  def solve(input, 1) do
    adapters = Enum.sort(input)
    outlet = [0]
    builtin = [List.last(adapters) + 3]

    {_, result} =
      outlet ++ adapters ++ builtin
      |> Enum.reduce({_prev = nil, %{1 => 0, 2 => 0, 3 => 0}}, fn
        n, {nil, acc} -> {n, acc}
        n2, {n1, acc} -> {n2, %{acc | (n2 - n1) => acc[n2 - n1] + 1}}
      end)

    result[1] * result[3]
  end

  def solve(input, 2) do
    adapters = Enum.sort(input)
    {_, elements} =
      [0 | adapters ++ [List.last(adapters) + 3]]
      |> Enum.reduce({0, [[]]}, fn e, {prev, [acc | rest_acc]} ->
        if prev + 1 >= e do
          {e, [[e | acc] | rest_acc]}
        else
          {e, [[e], acc | rest_acc]}
        end
      end)

    elements
    |> Stream.map(&count_paths(&1, 1))
    |> Enum.reduce(1, & &1 * &2)
  end

  def count_paths([e1, e2, e3, e4 | elements], acc) when e1 + 3 >= e4 do
    count_paths([e2, e3, e4 | elements], acc) +
    count_paths([e3, e4 | elements], 1) +
    count_paths([e4 | elements], 1)
  end
  def count_paths([e1, e2, e3 | elements], acc) when e1 + 3 >= e3 do
    count_paths([e2, e3 | elements], acc) +
    count_paths([e3 | elements], 1)
  end
  def count_paths([e1, e2 | elements], acc) when e1 + 3 >= e2 do
    count_paths([e2 | elements], acc)
  end
  def count_paths(_elements, acc) do
    acc
  end
end
