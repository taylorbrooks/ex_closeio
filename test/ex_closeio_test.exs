defmodule ExCloseioTest do
  use ExUnit.Case, async: true

  setup_all do
    HTTPoison.start
    :ok
  end

  test "lead - single" do
    api_key = System.get_env("CLOSEIO_API_KEY")
    id = "lead_lw2TrH5eMLnFz70UdF6f8zx3ElL6cPM0MHkgu4IzTFQ"

    {:ok, lead} = ExCloseio.Lead.find(id, api_key)
    assert lead.id, id
  end

  test "lead - search" do
    api_key = System.get_env("CLOSEIO_API_KEY")
    params  = %{query: "custom.status:skipped"}

    {:ok, leads} = ExCloseio.Lead.all(params, api_key)

    assert leads.total_results == 670
  end

  test "lead - paginated search" do
    api_key = System.get_env("CLOSEIO_API_KEY")
    leads   = %{query: "custom.current_system:paypal"}
              |> ExCloseio.Lead.paginate(api_key)

    assert Enum.count(leads) == 1580
  end

  test "update lead" do
    lead_id = "lead_lw2TrH5eMLnFz70UdF6f8zx3ElL6cPM0MHkgu4IzTFQ"

    {:ok, lead} = ExCloseio.Lead.update(lead_id, %{"custom.Drip Emails: Next Template" => nil })
    assert lead.id, lead_id
  end

  test "get events" do
    ExCloseio.Event.get_events(%{object_type: "lead", action: "deleted"})
    # If it didn't explode, it works.
  end

  test "get all events" do
    ExCloseio.Event.get_all_events(%{})
    # If it didn't explode, it works.
  end

end
