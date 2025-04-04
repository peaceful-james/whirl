defmodule WhirlWeb.ErrorHTMLTest do
  use WhirlWeb.ConnCase, async: true

  import Phoenix.Template, only: [render_to_string: 4]

  # Bring render_to_string/4 for testing custom views
  test "renders 404.html" do
    assert render_to_string(WhirlWeb.ErrorHTML, "404", "html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(WhirlWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
