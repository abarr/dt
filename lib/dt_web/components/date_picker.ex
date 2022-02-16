defmodule DtWeb.Components.DatePicker do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def handle_event("next-month", _, socket) do
    date = Date.end_of_month(socket.assigns.current_date) |> Date.add(1)
    {:noreply, assign(socket, current_date: date)}
  end

  def handle_event("prev-month", _, socket) do
    date = socket.assigns.current_date
    {:noreply, assign(socket, current_date: previous_month(date))}
  end

  def handle_event("date_selected", %{"date" => date, "id" => id}, socket) do
    {:ok, date} = Date.from_iso8601(date)
    send(self(), {:date_selected, date, id})
    {:noreply, assign(socket, selected_date: date)}
  end

  def render(assigns) do
    ~H"""
    <div id={@id} class="">
      <div class="relative" phx-click={JS.toggle(to: "#picker_#{@id}", in: {"ease-in duration-300", "opacity-0", "opacity-100"}, out: {"ease-out duration-300", "opacity-100", "opacity-0"})} phx-target={@myself}>
        <div class="w-96 max-w-md flex-none border-l border-gray-100 py-2 block">
          <div>
            <label for="selected_date" class="block text-sm font-medium text-gray-700">Date</label>
            <div class="mt-1 relative rounded-md shadow-sm">
              <input type="text" name="selected_date" value={unless is_nil(@selected_date), do: Calendar.strftime(@selected_date, "%d %b %Y")} readonly class="block w-full pr-10 sm:text-sm border-gray-300 rounded-md" placeholder="Select date">
              <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                  <!-- Heroicon name: solid/question-mark-circle -->
                  <svg class="h-5 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                  </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div id={"picker_#{@id}"} class="hidden w-96 max-w-md absolute z-40 bg-white" >
        <div phx-click-away={JS.hide(to: "#picker_#{@id}")} phx-target={@myself} class=" flex-none border-l border-gray-100 py-2 px-8 block">
          <div class="flex items-center text-center text-gray-900">
            <button type="button" class="-m-1.5 flex flex-none items-center justify-center p-1.5 text-gray-400 hover:text-gray-500" phx-target={@myself} phx-click={JS.push("prev-month", loading: "#picker_#{@id}")}>
              <span class="sr-only">Previous month</span>
                <!-- Heroicon name: solid/chevron-left -->
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
            </button>
            <div class="flex-auto font-semibold"><%= Calendar.strftime(@current_date, "%B %Y") %></div>
            <button type="button" class="-m-1.5 flex flex-none items-center justify-center p-1.5 text-gray-400 hover:text-gray-500" phx-target={@myself} phx-click={JS.push("next-month", loading: "#picker_#{@id}")}>
              <span class="sr-only">Next month</span>
              <!-- Heroicon name: solid/chevron-right -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
              </svg>
            </button>
          </div>
          <div class="mt-6 grid grid-cols-7 text-center text-xs leading-6 text-gray-500">
            <%= for day <- days() do %>
              <div><%= day %></div>
            <% end %>
          </div>
          <div class="isolate mt-2 grid grid-cols-7 gap-px bg-gray-200 text-sm shadow ring-1 ring-gray-200 ring-rounded-lg">
            <%= for week <- week_rows(@current_date), date <- week  do %>
              <%= if before_or_equal?(date, assigns[:min]) or after_or_equal?(date, assigns[:max]) do %>
                <button type="button" class={"bg-white py-1.5 text-gray-400 bg-white bg-gray-100"}>
                  <time class={"mx-auto flex h-7 w-7 items-center justify-center rounded-full"}>
                    <%= Calendar.strftime(date, "%d") %>
                  </time>
                </button>
              <% else %>
                <button type="button" class={"bg-white py-1.5 text-gray-400 bg-white hover:bg-gray-100 focus:z-10 #{if @today == date, do: "bg-gray-100"}"} phx-target={@myself}
                      phx-click={Phoenix.LiveView.JS.push("date_selected", value: %{date: date, id: @id}) |> JS.hide(to: "#picker_#{@id}")}>
                  <time class={"mx-auto flex h-7 w-7 items-center justify-center rounded-full #{if @selected_date == date, do: "bg-gray-600 font-normal text-white"} "}>
                    <%= Calendar.strftime(date, "%d") %>
                  </time>
                </button>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp days() do
    ["S", "M", "T", "W", "T", "F", "S"]
  end

  defp week_rows(current_date) do
    first =
      current_date
      |> Date.beginning_of_month()
      |> Date.beginning_of_week(:sunday)

    last =
      current_date
      |> Date.end_of_month()
      |> Date.end_of_week(:sunday)

    Date.range(first, last) |> Enum.map(& &1) |> Enum.chunk_every(7)
  end

  defp previous_month(date) do
    Date.beginning_of_month(date)
    |> Date.add(-1)
  end

  defp before_or_equal?(_, nil), do: false
  defp before_or_equal?(date, min) do
    case Date.compare(date, min) do
      :gt -> false
      _ -> true
    end
  end

  defp after_or_equal?(_, nil), do: false
  defp after_or_equal?(date, max) do
    case Date.compare(date, max) do
      :lt -> false
      _ -> true
    end
  end

end
