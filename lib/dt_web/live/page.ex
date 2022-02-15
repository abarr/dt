defmodule DtWeb.Page do
  use Phoenix.LiveView

  alias DtWeb.Components.DatePicker


  def mount(_params, _session, socket) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date()
    socket =
      socket
      |> assign(:today, today)
      |> assign(:selected_dates, %{})

    {:ok, socket}
  end

  def handle_info({:date_selected, date, id}, socket) do
    selected_dates = Map.put(socket.assigns.selected_dates, id, date)
    socket = assign(socket, :selected_dates, selected_dates)
    {:noreply, socket}
  end

  defp get_date(comp_id, selected_dates) do
    date =
      Map.get(selected_dates, comp_id)

    if is_nil(date) do
      "No date selected"
    else
      Calendar.strftime(date, "%d %b %Y")
    end
  end

end
