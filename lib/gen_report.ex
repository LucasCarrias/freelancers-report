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

  def build() do
    { :error, "Insira o nome de um arquivo" }
  end

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> generate()
  end

  defp generate(list) do
    %{
      "all_hours" => process_all_hours(list),
      "hours_per_month" => process_hours_per_month(list),
      "hours_per_year" => process_hours_per_year(list)
    }
  end

  defp get_all_names(list) do
    list
    |> Enum.map(&List.first/1)
    |> Enum.uniq()
  end

  defp get_all_years(list) do
    list
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
  end

  defp build_all_months() do
    Enum.into(@months, %{}, &{&1, 0})
  end

  defp build_all_years(list) do
    list
    |> get_all_years()
    |> Enum.into(%{}, &{&1, 0})
  end

  # All Hours

  defp build_all_hours(list) do
    list
    |> get_all_names()
    |> Enum.into(%{}, &{&1, 0})
  end

  defp sum_all_hours([name, hours, _, _, _], report) do
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

  defp sum_hours_per_month([name, hours, _, month, _], report) do
    worker_months = Map.put(report[name], month, report[name][month] + hours)
    Map.put(report, name, worker_months)
  end

  defp process_hours_per_month(list) do
    report = build_hours_per_month(list)
    Enum.reduce(list, report, fn line, acc -> sum_hours_per_month(line, acc) end)
  end

  # Hours per year

  defp build_hours_per_year(list) do
    Enum.into(get_all_names(list), %{}, &{&1, build_all_years(list)})
  end

  defp sum_hours_per_year([name, hours, _, _, year], report) do
    worker_years = Map.put(report[name], year, report[name][year] + hours)
    Map.put(report, name, worker_years)
  end

  defp process_hours_per_year(list) do
    report = build_hours_per_year(list)
    Enum.reduce(list, report, fn line, acc -> sum_hours_per_year(line, acc) end)
  end
end
