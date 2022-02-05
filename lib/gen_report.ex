defmodule GenReport do
  alias GenReport.Parser

  def build(), do: {:error, "Insira o nome de um arquivo"}

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> generate()
  end

  defp generate(list) do
    %{
      "all_hours" => calculate(&sum_all_hours/2, list),
      "hours_per_month" => calculate(&sum_hours_per_month/2, list),
      "hours_per_year" => calculate(&sum_hours_per_year/2, list)
    }
  end

  def calculate(fun, list) do
    Enum.reduce(list, %{}, fn line, acc -> fun.(line, acc) end)
  end

  defp sum_all_hours([name, hours, _, _, _], report) do
    sum_hours = Map.get(report, name, 0) + hours
    Map.put(report, name, sum_hours)
  end

  defp sum_hours_per_month([name, hours, _, month, _], report) do
    worker_report = Map.get(report, name, %{})
    month_hours = Map.get(worker_report, month, 0)

    Map.put(
      report,
      name,
      Map.put(worker_report, month, month_hours + hours)
    )
  end

  defp sum_hours_per_year([name, hours, _, _, year], report) do
    worker_report = Map.get(report, name, %{})
    year_hours = Map.get(worker_report, year, 0)

    Map.put(
      report,
      name,
      Map.put(worker_report, year, year_hours + hours)
    )
  end
end
