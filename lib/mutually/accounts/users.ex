defmodule Mutually.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  @derive{Jason.Encoder, only: [:id, :email]}
  schema "users" do
    field :email, :string
    field :hash_password, :string
    has_one :profile, Mutually.Profiles.Profile
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email, :hash_password])
    |> validate_format(:email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,message: "must have @ sign and no spaces")
    |> unique_constraint(:email)
    |> put_password_hash()
  end


  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}}=changeset) do
    change(changeset,hash_password: Bcrypt.hash_pwd_salt(hash_password))
  end

end
