defmodule ExCloseio.Event do
  @moduledoc """
    Event handles communication with the event related
    methods of the Close.io API.

    See https://developer.close.io/#event-log
  """

  import ExCloseio.Base
  @url_part "/event/"

  def get_page(params, api_key \\ :global) do
    get(@url_part, api_key, params)
  end

  def get_events(params, api_key \\ :global) do
    case get_page(params, api_key) do
      {:ok, page} -> page["data"]
      other -> other
    end
  end

  def get_all_pages(params, api_key \\ :global) do
    {:ok, first_page} = get_page(params, api_key)
    get_all_pages_r([first_page], params, api_key)
  end

  def get_all_events(params, api_key \\ :global) do
    pages = get_all_pages(params, api_key)
    Enum.reduce(pages, [], fn(page, events) -> events ++ page["data"] end)
  end

  defp get_all_pages_r(pages, params, api_key \\ :global) do
    current_page = List.last(pages)
    case get_next_page(current_page, params, api_key) do
      {:ok, next_page} -> get_all_pages_r(pages ++ [next_page], params, api_key)
      nil -> pages
    end
  end

  def get_next_page(page, params, api_key \\ :global)
  def get_next_page(%{"cursor_next" => nil}, _params, _api_key) do
    nil
  end
  def get_next_page(%{"cursor_next" => cursor}, params, api_key) do
    get_page(Map.put(params, :_cursor, cursor), api_key)
  end

  def get_prev_page(page, params, api_key \\ :global)
  def get_prev_page(%{"cursor_previous" => nil}, _params, _api_key) do
    nil
  end
  def get_prev_page(%{"cursor_previous" => cursor}, params, api_key) do
    get_page(Map.put(params, :_cursor, cursor), api_key)
  end

  def find(id, api_key \\ :global) do
    get(@url_part <> id, api_key)
  end

end
