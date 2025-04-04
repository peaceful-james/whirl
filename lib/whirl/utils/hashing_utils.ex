defmodule Whirl.Utils.HashingUtils do
  @moduledoc """
  Abstract the exact choice of hashing lib

  This allows using different libs in, e.g. dev vs prod.

  The Bcrypt lib is lighter and faster.
  The Argon2 lib is more secure but heavier/slower.
  """

  alias Ecto.Changeset

  @hashing_module if Application.compile_env(:whirl, :env) == :prod, do: Argon2, else: Bcrypt

  defdelegate hash_pwd_salt(password), to: @hashing_module
  defdelegate verify_pass(password, hashed_password), to: @hashing_module
  defdelegate no_user_verify, to: @hashing_module

  case @hashing_module do
    Bcrypt ->
      @doc "If using Bcrypt, then further validate it is at most 72 bytes long"
      def maybe_validate_max_length_of_hashable_field(changeset, field) do
        Changeset.validate_length(changeset, field, max: 72, count: :bytes)
      end

    Argon2 ->
      @doc "Argon2 does not have a max byte length for the key"
      def maybe_validate_max_length_of_hashable_field(changeset, _field), do: changeset
  end
end
