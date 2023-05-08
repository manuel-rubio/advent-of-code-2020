defmodule Advento do
  @moduledoc """
  Documentation for `Advento`.
  """

  def main([]) do
    IO.puts("Syntax: advento -d <i>")
  end
  def main(["-d", day]) do
    mod = Module.concat([Advento, "Day#{String.pad_leading(day, 2, "0")}", Solver])
    data = mod.read()
    IO.puts(mod.solve(data, 1))
    IO.puts(mod.solve(data, 2))
  end
end
