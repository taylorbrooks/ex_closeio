defmodule ExCloseio.BulkAction do
  @moduledoc """
    BulkAction handles communication with the bulk action related
    methods of the Close.io API.

    See http://developer.close.io/#bulk-actions
  """

  import ExCloseio.Base
  @url_part "/bulk_action/"

  def edit(params, api_key \\ :global) do
    post(@url_part <> "edit/", api_key, params)
  end

end
