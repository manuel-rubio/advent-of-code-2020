defmodule Advento.Day08.Solver do
  @filename "input08.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.with_index(1)
    |> Enum.map(fn {<<instruction :: binary-size(3), " ", number :: binary()>>, idx} ->
      {idx, {String.to_atom(instruction), String.to_integer(number)}}
    end)
    |> Map.new()
  end

  def solve(input, 1) do
    {:loop, value} = run(input)
    value
  end

  def solve(input, 2) do
    fixit(input, map_size(input))
  end

  def fixit(code, idx) do
    case code[idx] do
      {:nop, n} ->
        code
        |> Map.put(idx, {:jmp, n})
        |> run()
        |> case do
          {:loop, _} -> fixit(code, idx - 1)
          {:end, acc} -> acc
        end
      {:jmp, n} ->
        code
        |> Map.put(idx, {:nop, n})
        |> run()
        |> case do
          {:loop, _} -> fixit(code, idx - 1)
          {:end, acc} -> acc
        end
      {:acc, _} ->
        fixit(code, idx - 1)
    end
  end

  defp run(code, acc \\ 0, idx \\ 1, stack \\ []) do
    cond do
      idx in stack -> {:loop, acc}
      is_nil(code[idx]) -> {:end, acc}
      true ->
        case code[idx] do
          {:nop, _} -> run(code, acc, idx + 1, [idx | stack])
          {:acc, n} -> run(code, acc + n, idx + 1, [idx | stack])
          {:jmp, n} -> run(code, acc, idx + n, [idx | stack])
        end
    end
  end
end
