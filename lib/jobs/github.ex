defmodule Jobs.Github do
  defstruct [:lang, :location]

  def parse_jobs(body) do
    Agent.start_link(fn -> nil end, name: __MODULE__)
    {:ok, vacancies, _tail} = :erlsom.parse_sax(body, [], &Jobs.Github.attr/2)
    vacancies
  end

  def attr({:startElement, _url, 'job', _, _}, acc) do
    [%Jobs.Vacancy{} | acc]
  end

  def attr({:startElement, _url, tag, _, _}, acc) do
    __MODULE__
      |> Agent.cast(&(&1=tag))
    acc
  end

  def attr({:characters, _value}, []), do: []

  def attr({:characters, value}, [hd | tail]) do
    tag = Agent.get(__MODULE__, &(&1))
    hd = _put(tag, value, hd)
    [hd | tail]
  end

  def attr(_el, acc), do: acc

  defp _put('location', val, vacancy), do: %{vacancy | location: val}
  defp _put('detail-url', val, vacancy), do: %{vacancy | link: val}
  defp _put('title', val, vacancy), do: %{vacancy | title: val}
  defp _put('name', val, vacancy), do: %{vacancy | company: val}
  defp _put('summary', val, vacancy), do: %{vacancy | description: List.to_string(val)}
  defp _put(_tag, _val, vacancy), do: vacancy

end

defimpl Jobs.Resource, for: Jobs.Github do

  @url "https://jobs.github.com/positions.xml"

  def jobs(stack) do
    url = @url <> _query(stack.lang, stack.location)
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
      do: Jobs.Github.parse_jobs(body)
  end

  defp _query(lang, nil), do: "?description=#{lang}"
  defp _query(lang, location), do: "?description=#{lang}&location=#{location}"
end
