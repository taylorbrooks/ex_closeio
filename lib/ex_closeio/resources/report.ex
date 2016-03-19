defmodule ExCloseio.Report do
  import ExCloseio.Base

  # OPTIONS [date_start, date_end, user_id]
  def activities(params, api_key \\ :global) do
    get("/report/activity/#{get_org_id}/", api_key, params)
  end

  # OPTIONS [date_start, date_end, user_id]
  def sent_emails(params, api_key \\ :global) do
    get("/report/sent_email/#{get_org_id}/", api_key, params)
  end

  defp get_org_id do
    {:ok, %{data: statuses}} = ExCloseio.LeadStatus.all(%{})
    statuses |> hd |> Map.fetch!(:organization_id)
  end

end
