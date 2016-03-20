defmodule ExCloseio.Lead do
  import ExCloseio.Base
  alias ExCloseio.ResultStream
  @url_part "/lead/"

  def url_part, do: @url_part

  def all(params, api_key \\ :global) do
    get(@url_part, api_key, params)
  end

  def paginate(params, api_key \\ :global) do
    leads = ResultStream.new(params, api_key, __MODULE__) |> Enum.to_list
    {:ok, leads}
  end

  def find(id, api_key \\ :global) do
    get(@url_part <> id, api_key)
  end

  def create(params, api_key \\ :global) do
    post("/lead", api_key, params)
  end

  def update(id, params, api_key \\ :global) do
    put(@url_part <> id, api_key, params)
  end

  def destroy(id, api_key \\ :global) do
    delete(@url_part <> id, api_key)
  end

  def merge(source_id, destination_id, api_key \\ :global) do
    post(@url_part <> "merge/", %{source: source_id, destination: destination_id}, api_key)
  end

end
