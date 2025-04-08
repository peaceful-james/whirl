defmodule WhirlWeb.ShortUrlLive.Form do
  use WhirlWeb, :live_view

  alias Whirl.Urls
  alias Whirl.Urls.ShortUrl

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage short_url records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="short_url-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:long_url]} type="text" label="Long url" />
        <.input field={@form[:short_url]} type="text" label="Short url" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Short url</.button>
          <.button navigate={return_path(@current_scope, @return_to, @short_url)}>Cancel</.button>
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
    short_url = Urls.get_short_url!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Short url")
    |> assign(:short_url, short_url)
    |> assign(:form, to_form(Urls.change_short_url(socket.assigns.current_scope, short_url)))
  end

  defp apply_action(socket, :new, _params) do
    short_url = %ShortUrl{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Short url")
    |> assign(:short_url, short_url)
    |> assign(:form, to_form(Urls.change_short_url(socket.assigns.current_scope, short_url)))
  end

  @impl true
  def handle_event("validate", %{"short_url" => short_url_params}, socket) do
    changeset = Urls.change_short_url(socket.assigns.current_scope, socket.assigns.short_url, short_url_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"short_url" => short_url_params}, socket) do
    save_short_url(socket, socket.assigns.live_action, short_url_params)
  end

  defp save_short_url(socket, :edit, short_url_params) do
    case Urls.update_short_url(socket.assigns.current_scope, socket.assigns.short_url, short_url_params) do
      {:ok, short_url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Short url updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, short_url)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_short_url(socket, :new, short_url_params) do
    case Urls.create_short_url(socket.assigns.current_scope, short_url_params) do
      {:ok, short_url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Short url created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, short_url)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _short_url), do: ~p"/short_url"
  defp return_path(_scope, "show", short_url), do: ~p"/short_url/#{short_url}"
end
