defmodule WhirlWeb.AxisLive.Index do
  @moduledoc false
  use WhirlWeb, :live_view

  alias Whirl.Vars

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Axes
        <:actions>
          <.button variant="primary" navigate={~p"/axes/new"}>
            <.icon name="hero-plus" /> New Axis
          </.button>
        </:actions>
      </.header>

      <.table
        id="axes"
        rows={@streams.axes}
        row_click={fn {_id, axis} -> JS.navigate(~p"/axes/#{axis}") end}
      >
        <:col :let={{_id, axis}} label="Name">{axis.name}</:col>
        <:col :let={{_id, axis}} label="Cardinality">{axis.cardinality}</:col>
        <:col :let={{_id, axis}} label="Options">{axis.options}</:col>
        <:action :let={{_id, axis}}>
          <div class="sr-only">
            <.link navigate={~p"/axes/#{axis}"}>Show</.link>
          </div>
          <.link navigate={~p"/axes/#{axis}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, axis}}>
          <.link
            phx-click={JS.push("delete", value: %{id: axis.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    Vars.subscribe_axes(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Listing Axes")
     |> stream(:axes, Vars.list_axes(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    axis = Vars.get_axis!(socket.assigns.current_scope, id)
    {:ok, _} = Vars.delete_axis(socket.assigns.current_scope, axis)

    {:noreply, stream_delete(socket, :axes, axis)}
  end

  @impl true
  def handle_info({type, %Whirl.Vars.Axis{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :axes, Vars.list_axes(socket.assigns.current_scope), reset: true)}
  end
end
