defmodule MutuallyWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """

  use MutuallyWeb, :controller

  def translate_errors_to_json(changeset) do
    errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    %{errors: errors}
  end

  def translate_error({msg, _opts}) do
    # Customize error translation here, if needed
    # For example, you could use Gettext for internationalization
    msg
  end
  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: MutuallyWeb.ChangesetJSON)
    |> json(translate_errors_to_json(changeset))
  end

  def call(conn,%Ecto.Changeset{} = changeset) do

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: MutuallyWeb.ChangesetJSON)
    |> json(translate_errors_to_json(changeset))

  end

  # def call(conn,_) do
  #   conn
  #   |> put_status(:bad_request)
  #   |> put_view(json: MutuallyWeb.ChangesetJSON)
  #   |> json(%{error: "Bad request"})
  # end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: MutuallyWeb.ErrorHTML, json: MutuallyWeb.ErrorJSON)
    |> render(:"404")
  end
end
