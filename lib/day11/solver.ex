defmodule Advento.Day11.Solver do
  @filename "input11.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {cell, idx} ->
        case cell do
          "." -> {idx, nil}
          "#" -> {idx, :busy}
          "L" -> {idx, :free}
        end
      end)
      |> Map.new()
    end)
    |> Enum.with_index()
    |> Enum.map(fn {line, idx} -> {idx, line} end)
    |> Map.new()
  end

  defp get_busy_around(map, x, y) do
    [
      map[x-1][y-1],
      map[x-1][y],
      map[x-1][y+1],
      map[x][y+1],
      map[x+1][y+1],
      map[x+1][y],
      map[x+1][y-1],
      map[x][y-1]
    ]
    |> Enum.filter(& &1 == :busy)
    |> Enum.count()
  end

  defp follow_line(_map, x, _y, x_inc, _y_inc, x_max, _y_max) when x + x_inc in [-1, x_max], do: 0
  defp follow_line(_map, _x, y, _x_inc, y_inc, _x_max, y_max) when y + y_inc in [-1, y_max], do: 0
  defp follow_line(map, x, y, x_inc, y_inc, x_max, y_max) do
    x = x + x_inc
    y = y + y_inc
    case map[x][y] do
      :busy -> 1
      :free -> 0
      nil -> follow_line(map, x, y, x_inc, y_inc, x_max, y_max)
    end
  end

  defp get_deep_busy_around(map, x_max, y_max, x, y) do
    following_line = fn(x_inc, y_inc) ->
      follow_line(map, x, y, x_inc, y_inc, x_max, y_max)
    end
    [
      following_line.(-1, -1),
      following_line.(-1, 0),
      following_line.(-1, 1),
      following_line.(0, 1),
      following_line.(1, 1),
      following_line.(1, 0),
      following_line.(1, -1),
      following_line.(0, -1)
    ]
    |> Enum.sum()
  end

  def take_a_round(map, kind) do
    x_max = map_size(map)
    y_max = map_size(map[0])
    for x <- 0..(x_max - 1) do
      line =
        for y <- 0..(y_max - 1) do
          case map[x][y] do
            nil -> {y, nil}
            :busy when kind == :deep ->
              {y, if(get_deep_busy_around(map, x_max, y_max, x, y) >= 5, do: :free, else: :busy)}
            :busy ->
              {y, if(get_busy_around(map, x, y) >= 4, do: :free, else: :busy)}
            :free when kind == :deep ->
              {y, if(get_deep_busy_around(map, x_max, y_max, x, y) == 0, do: :busy, else: :free)}
            :free ->
              {y, if(get_busy_around(map, x, y) == 0, do: :busy, else: :free)}
          end
        end
      {x, Map.new(line)}
    end
    |> Map.new()
  end

  def count_busy_seats(map) do
    Enum.reduce(map, 0, fn {_, line}, acc ->
      Enum.reduce(line, acc ,fn {_, cell}, busy ->
        case cell do
          :busy -> busy + 1
          _ -> busy
        end
      end)
    end)
  end

  def take_rounds(map, kind) do
    new_map = take_a_round(map, kind)
    if new_map == map do
      count_busy_seats(map)
    else
      take_rounds(new_map, kind)
    end
  end

  def solve(input, 1) do
    take_rounds(input, :simple)
  end

  def solve(input, 2) do
    take_rounds(input, :deep)
  end
end
