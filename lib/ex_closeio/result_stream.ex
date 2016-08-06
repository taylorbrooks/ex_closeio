defmodule ExCloseio.ResultStream do
  alias ExCloseio.Base

  def new(params, api_key, module) do
    Stream.resource(
      fn -> fetch_page(params, module, api_key) end,
      &process_page/1,
      fn _ -> end
    )
  end

  defp fetch_page(params, module, api_key) do
    results = module.all(params, api_key)

    {:ok, %{"has_more" => has_more, "data" => items}} = results
    {items, params, has_more, module, api_key}
  end

  defp process_page({nil, _, false, _, api_key}) do
    {:halt, nil}
  end

  defp process_page({nil, params, has_more, module, api_key}) do
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
