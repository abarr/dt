defmodule DtWeb.Components.DateTime do
  use Phoenix.LiveComponent
  alias DtWeb.Components.{DatePicker, TimeInput}

  def render(assigns) do
    ~H"""
    <div id={@id} class="flex space-x-5">
        <.live_component
            module={DatePicker}
            id={"date_#{@id}"}
            selected_date={nil}
            current_date={@today}
            today={@today}
        />
        <.live_component
          module={TimeInput}
          id={"time_#{@id}"}
          time={NaiveDateTime.local_now() |> NaiveDateTime.to_time()}
          invalid={false}
          />
    </div>
    """
  end
end
