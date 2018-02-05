defprotocol Jobs.Resource do
  @moduledoc """
  A protocol for dealing with the
  various forms of job resources.
  """
  @doc "get the job vacancies."
  def jobs(lang)
end
