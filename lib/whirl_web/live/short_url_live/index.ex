defmodule WhirlWeb.ShortUrlLive.Index do
  use WhirlWeb, :live_view

  alias Whirl.Urls

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Short url
        <:actions>
          <.button variant="primary" navigate={~p"/short_url/new"}>
            <.icon name="hero-plus" /> New Short url
          </.button>
        </:actions>
      </.header>

      <.table
        id="short_url"
        rows={@streams.short_url_collection}
        row_click={fn {_id, short_url} -> JS.navigate(~p"/short_url/#{short_url}") end}
      >
        <:col :let={{_id, short_url}} label="Long url">{short_url.long_url}</:col>
        <:col :let={{_id, short_url}} label="Short url">{short_url.short_url}</:col>
        <:action :let={{_id, short_url}}>
          <div class="sr-only">
            <.link navigate={~p"/short_url/#{short_url}"}>Show</.link>
          </div>
          <.link navigate={~p"/short_url/#{short_url}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, short_url}}>
          <.link
            phx-click={JS.push("delete", value: %{id: short_url.id}) |> hide("##{id}")}
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
    Urls.subscribe_short_url(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Listing Short url")
     |> stream(:short_url_collection, Urls.list_short_url(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    short_url = Urls.get_short_url!(socket.assigns.current_scope, id)
    {:ok, _} = Urls.delete_short_url(socket.assigns.current_scope, short_url)

    {:noreply, stream_delete(socket, :short_url_collection, short_url)}
  end

  @impl true
  def handle_info({type, %Whirl.Urls.ShortUrl{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :short_url_collection, Urls.list_short_url(socket.assigns.current_scope), reset: true)}
  end
end
