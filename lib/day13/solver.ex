defmodule Advento.Day13.Solver do
  @filename "input13_1.txt"

  def read() do
    [ts, buses] =
      @filename
      |> File.read!()
      |> String.split("\n")
      |> Enum.filter(& &1 != "")

    buses =
      buses
      |> String.split(",")
      |> Enum.map(fn
        ("x") -> nil
        (i) -> String.to_integer(i)
      end)

    {String.to_integer(ts), buses}
  end

  def solve({ts, buses}, 1) do
    [{min, bus_line} | _] =
      buses
      |> Enum.reject(&is_nil/1)
      |> Enum.map(fn bus ->
        {(ceil(ts / bus) * bus) - ts, bus}
      end)
      |> Enum.sort()

    min * bus_line
  end

  def solve({_ts, buses}, 2) do
    data =
      buses
      |> Enum.with_index()
      |> Enum.reject(fn {bus, _} -> is_nil(bus) end)

    [{first_n, _}, {second_n, first_o} | rest] = data
    ini_n = first_n - second_n
    ini_o = -first_o
    {numbers, offset} = Enum.reduce(rest, {ini_n, ini_o}, fn {n, o}, {n_acc, o_acc} -> {n_acc - n, o + o_acc} end)
    times = 2 - Enum.count(data)
    find_i(1, numbers, offset, times)
  end

  def find_i(i, numbers, offset, times) do
    IO.inspect({i * numbers + offset, times})
    if 0 == rem((i * numbers + offset), times) do
      i
    else
      find_i(i + 1, numbers, offset, times)
    end
  end

  def search_greatest_timestamp(data) do
    for {bus, offset} <- data do
      bus + offset
    end
    |> Enum.reduce(1, & &1 * &2)
  end

  def get_data_offset([{first_bus, 0} | data], i) do
    ts = first_bus * i
    for {bus, offset} <- data do
      rem(ts + offset, bus)
    end
  end

  def find([{first_bus, _offset} | _] = data, i) do
    data
    |> get_data_offset(i)
    |> Enum.all?(& &1 == 0)
    |> case do
      true -> i * first_bus
      false -> find(data, i + 1)
    end
  end
end
