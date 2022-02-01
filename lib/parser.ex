defmodule GenReport.Parser do
  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(3, fn value -> @months[value] end)
    |> List.update_at(0, fn value -> String.downcase(value) end)
    |> Enum.map(&to_interger(&1))
  end

  defp is_number?(value), do: String.match?(value, ~r/^[[:digit:]]+$/)

  defp to_interger(value) do
    if is_number?(value), do: String.to_integer(value), else: value
  end
end
