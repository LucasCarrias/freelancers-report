defmodule GenReport do
  alias GenReport.Parser

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> generate()
  end

  defp generate(list) do
    %{
      all_hours: process_all_hours(list)
    }
  end

  defp all_names(list) do
    list
    |> Enum.map(&List.first/1)
    |> Enum.uniq()
  end

  # All Hours

  defp build_all_hours(list) do
    Enum.into(all_names(list), %{}, &{&1, 0})
  end

  defp sum_all_hours(line, report) do
    [name, hours, _, _, _] = line
    Map.put(report, name, report[name] + hours)
  end

  defp process_all_hours(list) do
    report = build_all_hours(list)
    Enum.reduce(list, report, fn line, acc -> sum_all_hours(line, acc) end)
  end
end
