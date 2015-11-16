defmodule ExCloseio.Organization do
  import ExCloseio.Base
  @url_part "/organization/"

  def find(id, api_key \\ :global) do
    get(@url_part <> id, api_key)
  end

  def update(id, params, api_key \\ :global) do
    put(@url_part <> id, params, api_key)
  end

end
