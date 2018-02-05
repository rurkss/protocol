defmodule Jobs do
  @moduledoc """
  Documentation for Jobs.
  """

  alias Jobs.{Resource, Github, Stackoverflow}

  def get(lang, location \\ nil) do
    [
      %Github{lang: lang, location: location},
      %Stackoverflow{lang: lang, location: location}
    ]
    |> Enum.map(&Resource.jobs/1)

  end
end
