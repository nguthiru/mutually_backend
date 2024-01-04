defmodule MutuallyWeb.ProfileJSON do
  alias Mutually.Profiles.Profile

  @doc """
  Renders a list of profiles.
  """
  def index(%{profiles: profiles}) do
    %{data: for(profile <- profiles, do: data(profile))}
  end

  @doc """
  Renders a single profile.
  """
  def show(%{profile: profile}) do
    %{data: data(profile)}
  end

  defp data(%Profile{} = profile) do
    %{
      id: profile.id,
      full_name: profile.full_name,
      bio: profile.bio
    }
  end
end
