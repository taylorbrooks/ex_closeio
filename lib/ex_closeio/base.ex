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
    request_and_retry(url_part, api_key, params, {:attempt, 1})
  end

  def request_and_retry(_url_part, _api_key, _params, {:error, reason}), do: {:error, reason}
  def request_and_retry(url_part, api_key, params, {:attempt, attempt}) do
    auth = set_basic_auth(api_key)

    [url_part, params]
    |> build_url
    |> HTTPoison.get!(@headers, auth)
    |> handle_response
    |> case do
      {:retry, reason} ->
        request_and_retry(url_part, api_key, params, attempt_again?(attempt, reason))
      res -> res
    end
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

  defp handle_response(%HTTPoison.Response{status_code: 429, body: body}),
    do: {:retry, Poison.decode!(body)}

  defp handle_response(%HTTPoison.Response{status_code: status, body: body}) do
    res = %{body: body |> Poison.decode!, status: status}
    {:error, res}
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

  def attempt_again?(attempt, reason) do
    if attempt >= 15 do
      {:error, reason}
    else
      attempt |> backoff
      {:attempt, attempt + 1}
    end
  end

  def backoff(attempt) do
    :math.pow(4, attempt) + 15 + (:rand.uniform(30) * attempt) * 1_000
    |> trunc
    |> :timer.sleep
  end

  defp set_basic_auth(:global) do
    api_key = System.get_env("CLOSEIO_API_KEY")
    [hackney: [basic_auth: {api_key, ""}], recv_timeout: 20_000]
  end

  defp set_basic_auth(api_key) do
    [hackney: [basic_auth: {api_key, ""}], recv_timeout: 20_000]
  end
end
