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
  and optionally a api_key, and a data Map.
  """
  def post(url_part, api_key, data \\ %{}) do
    auth = set_basic_auth(api_key)
    body = Poison.encode!(data)

    [url_part]
    |> build_url
    |> HTTPoison.post!(body, @headers, auth)
    |> handle_response
  end

  def put(url_part, api_key, data \\ %{}) do
    auth = set_basic_auth(api_key)
    body = Poison.encode!(data)

    [url_part]
    |> build_url
    |> HTTPoison.put!(body, @headers, auth)
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

  defp handle_response(%HTTPoison.Response{status_code: 200, body: body}),
    do: {:ok, Poison.decode!(body)}

  defp handle_response(%HTTPoison.Response{status_code: status, body: body}) do
    res = Poison.decode!(body)
    raise(ExCloseio.Error, [
      code: status,
      message: res["meta"]["error_type"] <> " " <> res["meta"]["error_message"]
    ])
  end

  defp build_url([part]) do
    @base_url <> part
    |> set_trailing_slash
  end

  defp build_url([part, []]) do
    @base_url <> part
    |> set_trailing_slash
  end

  defp build_url([part, params]) do
    "#{@base_url}#{part}?#{URI.encode_query(params)}"
  end

  defp set_trailing_slash(string) do
    string
    |> String.ends_with?("/")
    |> case do
      true  -> string
      false -> string <> "/"
    end
  end

  defp set_basic_auth(:global) do
    api_key = System.get_env("CLOSEIO_API_KEY")
    [hackney: [basic_auth: {api_key, ""}], recv_timeout: 20_000]
  end

  defp set_basic_auth(api_key) do
    [hackney: [basic_auth: {api_key, ""}], recv_timeout: 20_000]
  end
end
