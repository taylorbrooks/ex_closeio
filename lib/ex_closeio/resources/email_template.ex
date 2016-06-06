defmodule ExCloseio.EmailTemplate do
  import ExCloseio.Base
  @url_part "/email_template"

  def all(params \\ [], api_key \\ :global) do
    get(@url_part, api_key, params)
  end

  def render(id, params, api_key \\ :global) do
    get(@url_part <> id <> "/render/", params)
  end

  def paginate(id, params, api_key \\ :global) do
    templates = ResultStream.new(params, api_key, __MODULE__) |> Enum.to_list
    {:ok, templates}
  end

  def find(id, api_key \\ :global) do
    get(@url_part <> id, api_key)
  end

  def create(params, api_key \\ :global) do
    post(@url_part, params, api_key)
  end

  def update(id, params, api_key \\ :global) do
    put(@url_part <> id, params, api_key)
  end

  def destroy(id, api_key \\ :global) do
    delete(@url_part <> id, api_key)
  end

end
