defmodule ExCloseio.User do
  @moduledoc """
    User handles communication with the user related
    methods of the Close.io API.

    See http://developer.close.io/#user
  """

  import ExCloseio.Base
  @url_part "/user/"

  def find(id, api_key \\ :global) do
    get(@url_part <> id, api_key)
  end

  def me(api_key \\ :global) do
    get("/me", api_key)
  end

end
