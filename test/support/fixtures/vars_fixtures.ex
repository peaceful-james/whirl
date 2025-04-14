defmodule Whirl.VarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Whirl.Vars` context.
  """

  @doc """
  Generate a axis.
  """
  def axis_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        cardinality: 42,
        name: "some name",
        options: ["option1", "option2"]
      })

    {:ok, axis} = Whirl.Vars.create_axis(scope, attrs)
    axis
  end
end
