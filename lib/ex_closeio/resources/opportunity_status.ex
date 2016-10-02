defmodule ExCloseio.OpportunityStatus do
  @moduledoc """
    OpportunityStatus handles communication with the opportunity status related
    methods of the Close.io API.

    See http://developer.close.io/#opportunity-statuses
  """

  import ExCloseio.Base
  @url_part "/status/opportunity/"

  def all(params, api_key \\ :global) do
    get(@url_part, api_key, params)
  end

  def find(id, api_key \\ :global) do
    get(@url_part <> id, api_key)
  end

  def create(params, api_key \\ :global) do
    post(@url_part, api_key, params)
  end

  def update(id, params, api_key \\ :global) do
    put(@url_part <> id, api_key, params)
  end

  def destroy(id, api_key \\ :global) do
    delete(@url_part <> id, api_key)
  end

end
