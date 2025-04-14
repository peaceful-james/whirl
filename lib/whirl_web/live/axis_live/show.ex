defmodule WhirlWeb.AxisLive.Show do
  @moduledoc false
  use WhirlWeb, :live_view

  alias Whirl.Vars

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Axis {@axis.id}
        <:subtitle>This is a axis record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/axes"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/axes/#{@axis}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit axis
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@axis.name}</:item>
        <:item title="Cardinality">{@axis.cardinality}</:item>
        <:item title="Options">{@axis.options}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Vars.subscribe_axes(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Show Axis")
     |> assign(:axis, Vars.get_axis!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Whirl.Vars.Axis{id: id} = axis},
        %{assigns: %{axis: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :axis, axis)}
  end

  def handle_info({:deleted, %Whirl.Vars.Axis{id: id}}, %{assigns: %{axis: %{id: id}}} = socket) do
    {:noreply,
     socket
     |> put_flash(:error, "The current axis was deleted.")
     |> push_navigate(to: ~p"/axes")}
  end
end
