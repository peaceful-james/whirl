defmodule WhirlWeb.ShortUrlLive.Show do
  use WhirlWeb, :live_view

  alias Whirl.Urls

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Short url {@short_url.id}
        <:subtitle>This is a short_url record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/short_url"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/short_url/#{@short_url}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit short_url
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Long url">{@short_url.long_url}</:item>
        <:item title="Short url">{@short_url.short_url}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Urls.subscribe_short_url(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Show Short url")
     |> assign(:short_url, Urls.get_short_url!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Whirl.Urls.ShortUrl{id: id} = short_url},
        %{assigns: %{short_url: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :short_url, short_url)}
  end

  def handle_info(
        {:deleted, %Whirl.Urls.ShortUrl{id: id}},
        %{assigns: %{short_url: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current short_url was deleted.")
     |> push_navigate(to: ~p"/short_url")}
  end
end
