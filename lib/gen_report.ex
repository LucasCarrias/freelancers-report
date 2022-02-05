defmodule GenReport do
  alias GenReport.Parser

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> generate()
  end

  defp generate(list) do
    %{
      all_hours: process_all_hours(list),
      hours_per_month: process_hours_per_month(list)
    }
  end

  defp get_all_names(list) do
    list
    |> Enum.map(&List.first/1)
    |> Enum.uniq()
  end

  defp build_all_months() do
    Enum.into(@months, %{}, &{&1, 0})
  end

  # All Hours

  defp build_all_hours(list) do
    list
    |> get_all_names()
    |> Enum.into(%{}, &{&1, 0})
  end

  defp sum_all_hours(line, report) do
    [name, hours, _, _, _] = line
    Map.put(report, name, report[name] + hours)
  end

  defp process_all_hours(list) do
    report = build_all_hours(list)
    Enum.reduce(list, report, fn line, acc -> sum_all_hours(line, acc) end)
  end

  # Hours per month

  defp build_hours_per_month(list) do
    Enum.into(get_all_names(list), %{}, &{&1, build_all_months()})
  end

  defp sum_hours_per_month(line, report) do
    [name, hours, _, month, _] = line
    worker_months = Map.put(report[name], month, report[name][month] + hours)
    Map.put(report, name, worker_months)
  end

  defp process_hours_per_month(list) do
    report = build_hours_per_month(list)
    Enum.reduce(list, report, fn line, acc -> sum_hours_per_month(line, acc) end)
  end
end
