defmodule ExCloseio.Base do
  @moduledoc """
  Provides general request making and handling functionality (for internal use).
  """
  @base_url "https://app.close.io/api/v1"
  @headers  [{"User-Agent", "ExCloseio"}, {"Content-Type", "application/json"}]

  @doc """
  General HTTP `GET` request function. Takes a url part
  and optionally a api_key and list of params.
  """
  def get(url_part, api_key, params \\ []) do
    auth = set_basic_auth(api_key)

    [url_part, params]
    |> build_url
    |> HTTPoison.get!(@headers, auth)
    |> handle_response
  end

  @doc """
  General HTTP `POST` request function. Takes a url part,
  and optionally a api_key, data Map and list of params.
  """
  def post(url_part, api_key, data \\ "", params \\ []) do
    auth = set_basic_auth(api_key)

    [url_part, params]
    |> build_url
    |> HTTPoison.post!(data, @headers, auth)
    |> handle_response
  end

  def put(url_part, api_key, params \\ []) do
    auth = set_basic_auth(api_key)

    [url_part, params]
    |> build_url
    |> HTTPoison.put!(@headers, auth)
    |> handle_response
  end

  @doc """
  General HTTP `DELETE` request function. Takes a url part
  and optionally a api_key and list of params.
  """
  def delete(url_part, api_key, params \\ []) do
    auth = set_basic_auth(api_key)

    [url_part, params]
    |> build_url
    |> HTTPoison.delete!(@headers, auth)
    |> handle_response
  end

  defp handle_response(data) do
    response = Poison.decode!(data.body, keys: :atoms)
    case data.status_code do
      200 -> {:ok, response}
      _ -> raise(ExCloseio.Error, [code: data.status_code, message: "#{response.meta.error_type}: #{response.meta.error_message}"])
    end
  end

  def build_url([part, []]) do
    "#{@base_url}#{part}/"
  end

  def build_url([part, params]) do
    "#{@base_url}#{part}?#{URI.encode_query(params)}"
  end

  def build_part(module) do
    module
    |> to_string
    |> String.split(".")
    |> Enum.reverse
    |> hd
    |> String.downcase
  end

  defp set_basic_auth(:global) do
    api_key = System.get_env("CLOSEIO_API_KEY")
    [hackney: [basic_auth: {api_key, ""}]]
  end

  defp set_basic_auth(api_key) do
    [hackney: [basic_auth: {api_key, ""}]]
  end
end
