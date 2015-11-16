defmodule ExCloseioTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes",
                                      "fixture/custom_cassettes")
    HTTPoison.start
    :ok
  end

  test "lead - single" do
    api_key = System.get_env("CLOSEIO_API_KEY")
    id = "lead_lw2TrH5eMLnFz70UdF6f8zx3ElL6cPM0MHkgu4IzTFQ"

    use_cassette "lead_single" do
      {:ok, lead} = ExCloseio.Lead.find(id, api_key)
      assert lead.id, id
    end
  end

  test "lead - search" do
    api_key = System.get_env("CLOSEIO_API_KEY")
    params  = %{query: "custom.status:skipped"}

    use_cassette "lead_search" do
      {:ok, leads} = ExCloseio.Lead.all(params, api_key)

      assert leads.total_results == 670
    end
  end

  test "lead - paginated search" do
    api_key = System.get_env("CLOSEIO_API_KEY")
    leads   = %{query: "custom.current_system:paypal"}
              |> ExCloseio.Lead.paginate(api_key)

    assert Enum.count(leads) == 1580
  end

end
