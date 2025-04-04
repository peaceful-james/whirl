[
  import_deps: [:ecto, :ecto_sql, :phoenix],
  subdirectories: ["priv/*/migrations"],
  plugins: [
    TailwindFormatter,
    Phoenix.LiveView.HTMLFormatter,
    Styler,
    Green.Lexmag.ElixirStyleGuideFormatter
  ],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
