defmodule DtWeb.Page do
  use Phoenix.LiveView
  alias DtWeb.Components.{DatePicker, TimeInput}

  def mount(_params, _session, socket) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date()
    socket =
      socket
      |> assign(:today, today)
      |> assign(:selected_dates, %{})
      |> assign(:times, %{})

    {:ok, socket}
  end

  def handle_info({:date_selected, date, id}, socket) do
    selected_dates = Map.put(socket.assigns.selected_dates, id, date)
    socket = assign(socket, :selected_dates, selected_dates)
    {:noreply, socket}
  end

  def handle_info({:time_updated, time, id}, socket) do
    times = Map.put(socket.assigns.times, id, time)
    socket = assign(socket, :times, times)
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

  defp get_time(comp_id, times) do
    time =
      Map.get(times, comp_id)

    if is_nil(time) do
      "No time input"
    else
      Calendar.strftime(time, "%H : %M")
    end
  end

end
