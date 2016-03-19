defmodule ExCloseio.User do
  import ExCloseio.Base
  @url_part "/user/"

  def find(id, api_key \\ :global) do
    get(@url_part <> id, api_key)
  end

  def me(api_key \\ :global) do
    get("/me", api_key)
  end

end
