defmodule ExCloseio.BulkAction do
  import ExCloseio.Base
  @url_part "/bulk_action/"

  def edit(params, api_key \\ :global) do
    post(@url_part <> "edit/", api_key, params)
  end

end
