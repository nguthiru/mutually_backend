defmodule MutuallyWeb.ProfileController do
  use MutuallyWeb, :controller

  alias Mutually.Mutuals
  alias Mutually.Profiles.InviteLink
  alias MutuallyWeb.FallbackController
  alias Mutually.Profiles
  alias Mutually.Profiles.Profile

  action_fallback MutuallyWeb.FallbackController

  def index(conn, _params) do
    # IO.inspect(conn)
    conn
    |> json(%{"profile" => conn.assigns.user.profile})
  end

  def me(conn, _params) do
    conn
    |> json(%{"profile" => conn.assigns.user.profile})
  end

  def create(conn, %{"profile" => profile_params}) do
    user = conn.assigns.user

    case Profiles.create_profile(user, profile_params) do
      {:ok, profile} ->
        conn
        |> put_status(:created)
        |> json(profile)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(FallbackController.translate_errors_to_json(changeset))
    end
  end

  def show(conn, %{"id" => id}) do
    profile1 = conn.assigns.user.profile
    case profile1.id == String.to_integer(id) do
      true ->
        conn
        |> json(profile1)

      false ->
        case Profiles.get_profile(id) do
          %Profile{} = profile2 ->
            case Mutuals.are_profile_mutual?(profile1, profile2) do
              true ->
                conn
                |> json(profile2)

              false ->
                conn
                |> put_status(:forbidden)
                |> json(%{"error" => "Profile is not a mutual"})
            end

          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{"error" => "Not Found"})
        end
    end
  end

  def update(conn, %{"profile" => profile_params}) do
    profile = conn.assigns.user.profile

    with {:ok, %Profile{} = profile} <- Profiles.update_profile(profile, profile_params) do
      conn
      |> put_status(:ok)
      |> json(profile)
    end
  end

  def get_invite_link(conn, _params) do
    with {:ok, %InviteLink{invite_link: invite_link}} <-
           Profiles.generate_profile_link(conn.assigns.user.profile) do
      conn
      |> json(%{"invite_link" => invite_link})
    end
  end

  def accept_invite(conn, %{"link" => invite_link}) do
    invite = Profiles.get_invite_link(invite_link)

    case invite do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{"error" => "Invite link is invalid"})

      %InviteLink{} ->
        case is_my_invite_link?(conn, invite) do
          true ->
            conn
            |> put_status(:bad_request)
            |> json(%{"error" => "You cannot accept your own invite link"})

          false ->
            case InviteLink.is_within_24_hours?(invite) do
              true ->
                case create_mutual_and_delete_link(
                       invite,
                       invite.profile,
                       conn.assigns.user.profile
                     ) do
                  {:ok, mutual} ->
                    conn
                    |> put_status(:ok)
                    |> json(%{"mutual" => mutual})

                  {:error, changeset} ->
                    conn
                    |> put_status(:unprocessable_entity)
                    |> json(FallbackController.translate_errors_to_json(changeset))
                end

                conn
                |> put_status(:ok)
                |> json(%{"profile" => invite.profile})

              false ->
                conn
                |> put_status(:bad_request)
                |> json(%{"error" => "Invite link has expired"})
            end
        end
    end
  end

  defp create_mutual_and_delete_link(
         %InviteLink{} = invite_link,
         %Profile{} = profile1,
         %Profile{} = profile2
       ) do
    case Mutuals.create_mutual(profile1, profile2) do
      {:ok, mutual} ->
        Profiles.delete_invite_link(invite_link)
        {:ok, mutual}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp is_my_invite_link?(conn, %InviteLink{profile_id: profile_id}) do
    conn.assigns.user.profile.id == profile_id
  end
end
