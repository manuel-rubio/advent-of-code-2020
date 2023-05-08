defmodule Advento.Day05.Solver do
  @filename "input05.txt"

  def read() do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(& &1 != "")
    |> Enum.map(fn <<row :: binary-size(7), column :: binary-size(3)>> ->
      row =
        row
        |> String.replace("F", "0")
        |> String.replace("B", "1")
        |> String.to_integer(2)

      column =
        column
        |> String.replace("L", "0")
        |> String.replace("R", "1")
        |> String.to_integer(2)

      %{row: row, column: column, seat: row * 8 + column}
    end)
  end

  def solve(input, 1) do
    Enum.max_by(input, & &1.seat)[:seat]
  end

  def solve(input, 2) do
    [%{seat: first_seat} | _] = input = Enum.sort_by(input, & &1.seat)
    {_, [my_seat]} =
      Enum.reduce(input, {first_seat - 1, []}, fn %{seat: seat}, {prev_seat, acc} ->
        if prev_seat + 1 < seat do
          {seat, [prev_seat + 1 | acc]}
        else
          {seat, acc}
        end
      end)

    my_seat
  end
end
