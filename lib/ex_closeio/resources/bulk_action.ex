defmodule ExCloseio.BulkAction do
  import ExCloseio.Base
  @url_part "/bulk_action/"

  def edit(params, api_key \\ :global) do
    post(@url_part <> "edit/", params, api_key)
  end

end
