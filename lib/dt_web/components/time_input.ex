defmodule DtWeb.Components.TimeInput do
  use Phoenix.LiveComponent

  def update(assigns, socket) do
    send(self(), {:time_updated, assigns[:time], assigns[:id]})
    socket = assign(socket, assigns)
    {:ok, socket}
  end

  def handle_event("validate", %{"value" => ""}, socket) do
    {:noreply, assign(socket, invalid: true)}
  end

  def handle_event("validate", %{"input" => "hour", "value" => val}, socket) do
    with {:ok, hr} <- to_integer(val),
          {:ok, _} <- validate_hour(hr) do
      current = socket.assigns.time
      time = Time.new!(hr, current.minute, 0)
      send(self(), {:time_updated, time, socket.assigns.id})
      {:noreply, assign(socket, invalid: false)}
    else
      :error ->
        {:noreply, assign(socket, invalid: true)}
    end
  end

  def handle_event("validate", %{"input" => "minute", "value" => val}, socket) do
    with {:ok, min} <- to_integer(val),
          {:ok, _} <- validate_minutes(min) do
      current = socket.assigns.time
      time = Time.new!(current.hour, min, 0)
      send(self(), {:time_updated, time, socket.assigns.id})
      {:noreply, assign(socket, time: time, invalid: false)}
    else
      :error ->
        {:noreply, assign(socket, invalid: true)}
    end
  end

  def render(assigns) do
    ~H"""
    <div id={@id} class="flex-none border-l border-gray-100 py-2 px-8 block">
        <div class="w-48">
          <div class="flex justify-between">
            <label for="selected_date" class="block text-sm font-medium text-gray-700">Time</label>
            <span class="text-sm text-gray-500" id="email-optional">24hr</span>
          </div>
          <div class="rounded-lg border w-48">
              <div class="flex items-center">
                  <input phx-keyup="validate" value={get_hours(@time)} phx-value-input="hour" phx-target={@myself} type="text" name="hour" class="text-sm py-2 text-right w-1/2 border-transparent focus:border-transparent focus:ring-0" placeholder="HH">
                  <span>:</span>
                  <input phx-keyup="validate" value={get_minutes(@time)} phx-value-input="minute" phx-value-id={@id} phx-target={@myself} type="text" name="minute"  class="text-sm py-2 w-1/2 border-transparent focus:border-transparent focus:ring-0" placeholder="MM">
              </div>
          </div>
          <%= if @invalid do %>
            <p class="text-sm text-red-800">Must be valid 24 hour time</p>
          <% end %>
        </div>
    </div>
    """
  end

  defp to_integer(val) do
    case Integer.parse(val) do
      {int, _} -> {:ok, int}
      _ -> :error
    end
  end

  defp validate_minutes(minutes) when minutes in 0..59, do: {:ok, minutes}
  defp validate_minutes(_minutes), do: :error

  defp validate_hour(hour) when hour in 0..23, do: {:ok, hour}
  defp validate_hour(_hour), do: :error

  defp get_minutes(time) do
    [_h, minutes, _] =
      time
      |> Time.to_iso8601()
      |> String.split(":")
    minutes
  end

  defp get_hours(time) do
    [hour, _m, _] =
      time
      |> Time.to_iso8601()
      |> String.split(":")
    hour
  end

end
