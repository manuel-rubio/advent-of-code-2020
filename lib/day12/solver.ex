defmodule Advento.Day12.Solver do
  @filename "input12.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(fn <<action :: binary-size(1), how_much :: binary()>> ->
      {action, String.to_integer(how_much)}
    end)
  end

  def turn_right(0, facing), do: facing
  def turn_right(r, :east), do: turn_right(r - 90, :south)
  def turn_right(r, :south), do: turn_right(r - 90, :west)
  def turn_right(r, :west), do: turn_right(r - 90, :north)
  def turn_right(r, :north), do: turn_right(r - 90, :east)

  def turn_right(0, wx, wy), do: {wx, wy}
  def turn_right(r, wx, wy), do: turn_right(r - 90, wy * -1, wx)

  def turn_left(0, facing), do: facing
  def turn_left(l, :east), do: turn_left(l - 90, :north)
  def turn_left(l, :north), do: turn_left(l - 90, :west)
  def turn_left(l, :west), do: turn_left(l - 90, :south)
  def turn_left(l, :south), do: turn_left(l - 90, :east)

  def turn_left(0, wx, wy), do: {wx, wy}
  def turn_left(l, wx, wy), do: turn_left(l - 90, wy, wx * -1)

  def process([], _facing, x, y), do: abs(x) + abs(y)
  def process([{"F", f} | rest], :east, x, y), do: process(rest, :east, x + f, y)
  def process([{"F", f} | rest], :west, x, y), do: process(rest, :west, x - f, y)
  def process([{"F", f} | rest], :north, x, y), do: process(rest, :north, x, y - f)
  def process([{"F", f} | rest], :south, x, y), do: process(rest, :south, x, y + f)
  def process([{"E", f} | rest], facing, x, y), do: process(rest, facing, x + f, y)
  def process([{"W", f} | rest], facing, x, y), do: process(rest, facing, x - f, y)
  def process([{"N", f} | rest], facing, x, y), do: process(rest, facing, x, y - f)
  def process([{"S", f} | rest], facing, x, y), do: process(rest, facing, x, y + f)
  def process([{"R", r} | rest], facing, x, y), do: process(rest, turn_right(r, facing), x, y)
  def process([{"L", l} | rest], facing, x, y), do: process(rest, turn_left(l, facing), x, y)

  def process([], x, y, _wx, _wy), do: abs(x) + abs(y)
  def process([{"F", f} | rest], x, y, wx, wy), do: process(rest, x + (f * wx), y + (f * wy), wx, wy)
  def process([{"E", f} | rest], x, y, wx, wy), do: process(rest, x, y, wx + f, wy)
  def process([{"W", f} | rest], x, y, wx, wy), do: process(rest, x, y, wx - f, wy)
  def process([{"N", f} | rest], x, y, wx, wy), do: process(rest, x, y, wx, wy - f)
  def process([{"S", f} | rest], x, y, wx, wy), do: process(rest, x, y, wx, wy + f)
  def process([{"R", r} | rest], x, y, wx, wy) do
    {wx, wy} = turn_right(r, wx, wy)
    process(rest, x, y, wx, wy)
  end
  def process([{"L", l} | rest], x, y, wx, wy) do
    {wx, wy} = turn_left(l, wx, wy)
    process(rest, x, y, wx, wy)
  end

  def solve(input, 1) do
    process(input, :east, 0, 0)
  end

  def solve(input, 2) do
    # ship (0, 0) waypoint east 10, north 1
    process(input, 0, 0, 10, -1)
  end
end
