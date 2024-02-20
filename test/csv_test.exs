defmodule CsvTest do
  use ExUnit.Case
  doctest Csv

  test "parses a CSV file" do
    {:ok, rows} = Csv.parse("test/fixtures/cities.csv")

    for row <- rows do
      assert is_map(row)
      assert Map.keys(row) == ["City", "Country", "Date of Foundation", "Population"]
    end

    assert Enum.count(rows) == 10
  end
end
