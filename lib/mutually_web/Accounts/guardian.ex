defmodule MutuallyWeb.Accounts.Guardian do
  use Guardian, otp_app: :mutually
  alias Mutually.Accounts.User
  alias Mutually.Accounts

  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      {:error, _changeset} -> {:error, :no_account}
      account -> {:ok, account}
    end
  end

  def resource_from_claims(_) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case Accounts.get_user_by_email(email) do
      nil ->
        {:error, :no_account}

      user ->
        case validate_password(password, user.hash_password) do
          true -> create_token(user)
          false -> {:error, :invalid_password}
        end
    end
  end

  defp validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  defp create_token(%User{} = user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
