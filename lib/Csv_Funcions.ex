defmodule Csv_Functions do
  @spec parse(binary()) :: {:ok, [map()]} | {:error, String.t()}
  def parse(file_path) do
     case csv_Validation(file_path) do
       {:ok, content} -> tuple_creator(content)
       {:error, reason} -> {:error, reason}
     end
  end


defp csv_Validation(file_path) do
  case File.read(file_path) do
    {:ok, ""} -> {:error, "File is empty"} #Caso o arquivo esteja vazio
    {:ok, content} -> {:ok, content}
    {:error, _reason} -> {:error, "File not found"} #Arquivo Não encontrado
  end
end

defp tuple_creator(content) do
  case String.split(content, "\n") do #Divide as linhas do arquivo
  [header | data_lines] -> #Separa a primeira linha do arquivo para o cabeçalho e o resto para os dados
    columns = String.split(String.trim_trailing(header, "\r"), ",") # Separa as colunas usando as virgulas
    case Enum.all?(data_lines, fn line -> length(String.split(line, ",")) == length(columns) end) do #Checa se tem a mesma quantidade de linhas e colunas
      true ->
        parsed_data = data_lines
        |> Enum.map(&String.trim_trailing(&1, "\r")) #Retira o caracter de retorno do resultado final (/r)
        |> Enum.map(&String.split(&1, ","))
        |> Enum.map(fn line -> Enum.zip(columns, line)
                               |> Enum.into(%{}) end) # Utiliza uma função anonima para juntar os headers com os dados e os coloca em tuplas
        mean_Population(parsed_data)
        IO.puts("\n")
        median_Population(parsed_data)
        IO.puts("\n")
        search_city(parsed_data)
        IO.puts("\n")
        search_Country(parsed_data)
        IO.puts("\n")
        size_Population(parsed_data)
        {:ok, parsed_data}
      false ->
        {:error, "Invalid CSV"}
    end
  end
end


defp mean_Population(parsed_data) do
    total_population = Enum.reduce(parsed_data, 0, fn city, acc_population ->
    acc_population + String.to_integer(city["Population"])
  end)

  total_cities = length(parsed_data)

  average_population = total_population / total_cities
  average_population_Int = round(average_population)

  IO.puts("Média da População: #{average_population_Int}")
end

defp median_Population(parsed_data) do
  populations = parsed_data
  |> Enum.map(&String.to_integer(&1["Population"]))
  populations_Sorted = Enum.sort(populations)
  length = length(populations_Sorted)
  middle = div(length,2)
  if rem(length(populations_Sorted), 2) == 0 do
    median = (Enum.at(populations_Sorted, middle-1) + Enum.at(populations_Sorted, middle))/2
    median_Int = round(median)
    IO.puts("Mediana da População: #{median_Int}")
  else
    median = Enum.at(populations_Sorted, middle)
    IO.puts("Mediana da População: #{median}")
  end
end

defp size_Population (parsed_data) do
  IO.puts("Diga qual tamanho minimo populacional")
  size = String.trim(IO.gets(""))
  case Enum.filter(parsed_data, fn population -> String.to_integer(population["Population"]) >= String.to_integer(size) end) do
    nil ->
      IO.puts("Nenhuma População com esse tamanho")
    population ->
      Enum.each(population, fn population ->
      IO.puts("Dados da cidade:")
      IO.puts("Nome: #{population["City"]}")
      IO.puts("País: #{population["Country"]}")
      IO.puts("Data de Fundação: #{population["Date of Foundation"]}")
      IO.puts("População: #{population["Population"]}")
      IO.puts("\n") end )
end
end

defp search_city(parsed_data) do
  IO.puts("Digite o nome da cidade:")
  city_name = String.trim(IO.gets(""))
  case Enum.find(parsed_data, fn city -> city["City"] == city_name end) do
    nil ->
    IO.puts("Cidade não encontrada")
    city ->
    IO.puts("Dados da cidade:")
    IO.puts("Nome: #{city["City"]}")
    IO.puts("País: #{city["Country"]}")
    IO.puts("Data de Fundação: #{city["Date of Foundation"]}")
    IO.puts("População: #{city["Population"]}")
  end
end

defp search_Country(parsed_data) do
  IO.puts("Digite o nome do Pais:")
  country_name = String.trim(IO.gets(""))
  case Enum.filter(parsed_data, fn country -> country["Country"] == country_name end) do
      nil ->
        IO.puts("Pais não encontrado")
      country ->
        Enum.each(country, fn country ->
        IO.puts("Dados da cidade:")
        IO.puts("Nome: #{country["City"]}")
        IO.puts("País: #{country["Country"]}")
        IO.puts("Data de Fundação: #{country["Date of Foundation"]}")
        IO.puts("População: #{country["Population"]}")
        IO.puts("\n") end )
  end
end

end
