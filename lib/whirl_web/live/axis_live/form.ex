defmodule WhirlWeb.AxisLive.Form do
  @moduledoc false
  use WhirlWeb, :live_view

  alias Whirl.Vars
  alias Whirl.Vars.Axis

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage axis records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="axis-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:cardinality]} type="number" label="Cardinality" />
        <.input
          field={@form[:options]}
          type="select"
          multiple
          label="Options"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Axis</.button>
          <.button navigate={return_path(@current_scope, @return_to, @axis)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    axis = Vars.get_axis!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Axis")
    |> assign(:axis, axis)
    |> assign(:form, socket.assigns.current_scope |> Vars.change_axis(axis) |> to_form())
  end

  defp apply_action(socket, :new, _params) do
    axis = %Axis{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Axis")
    |> assign(:axis, axis)
    |> assign(:form, socket.assigns.current_scope |> Vars.change_axis(axis) |> to_form())
  end

  @impl true
  def handle_event("validate", %{"axis" => axis_params}, socket) do
    changeset = Vars.change_axis(socket.assigns.current_scope, socket.assigns.axis, axis_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"axis" => axis_params}, socket) do
    save_axis(socket, socket.assigns.live_action, axis_params)
  end

  defp save_axis(socket, :edit, axis_params) do
    case Vars.update_axis(socket.assigns.current_scope, socket.assigns.axis, axis_params) do
      {:ok, axis} ->
        {:noreply,
         socket
         |> put_flash(:info, "Axis updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, axis)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_axis(socket, :new, axis_params) do
    case Vars.create_axis(socket.assigns.current_scope, axis_params) do
      {:ok, axis} ->
        {:noreply,
         socket
         |> put_flash(:info, "Axis created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, axis)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _axis), do: ~p"/axes"
  defp return_path(_scope, "show", axis), do: ~p"/axes/#{axis}"
end
