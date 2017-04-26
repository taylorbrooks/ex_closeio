defmodule ExCloseio.ResultStream do
  @moduledoc ""

  def new(params, api_key, module) do
    Stream.resource(
      fn -> fetch_page(params, module, api_key) end,
      &process_page/1,
      fn _ -> :ok end
    )
  end

  defp fetch_page(params, module, api_key) do
    module.all(params, api_key)
    |> case do
      {:error, _} -> :error
      {:ok, %{"has_more" => has_more, "data" => items}} ->
        {items, params, has_more, module, api_key}
    end
  end

  defp process_page(:error),
    do: {:halt, nil}
  defp process_page({nil, _, false, _, _}),
    do: {:halt, nil}

  defp process_page({nil, params, _, module, api_key}) do
    params
    |> Map.update("_skip", 100, fn(val) -> val+100 end)
    |> Map.merge(%{"_limit" => 100})
    |> fetch_page(module, api_key)
    |> process_page
  end

  defp process_page({items, params, has_more, module, api_key}) do
    {items, {nil, params, has_more, module, api_key}}
  end
end
