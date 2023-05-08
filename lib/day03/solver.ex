defmodule Advento.Day03.Solver do
  @filename "input03.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(&String.graphemes/1)
  end

  def solve([head | _] = input, 1) do
    y_max = length(input)
    x_max = length(head)
    x_slope = 3
    y_slope = 1
    find(input, 0, 0, x_slope, y_slope, x_max, y_max, 0)
  end

  def solve([head | _] = input, 2) do
    y_max = length(input)
    x_max = length(head)
    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]
    slope_results =
      for {x_slope, y_slope} <- slopes do
        find(input, 0, 0, x_slope, y_slope, x_max, y_max, 0)
      end

    Enum.reduce(slope_results, 1, & &1 * &2)
  end

  def find(input, x, y, x_slope, y_slope, x_max, y_max, acc) do
    acc =
      if get_point(input, x, y) == "#" do
        acc + 1
      else
        acc
      end

    x = rem(x + x_slope, x_max)
    y = y + y_slope
    if y >= y_max do
      acc
    else
      find(input, x, y, x_slope, y_slope, x_max, y_max, acc)
    end
  end

  def get_point(input, x, y) do
    input
    |> Enum.at(y)
    |> Enum.at(x)
  end
end
