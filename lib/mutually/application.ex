defmodule Mutually.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MutuallyWeb.Telemetry,
      Mutually.Repo,

      {DNSCluster, query: Application.get_env(:mutually, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mutually.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mutually.Finch},
      # Start a worker by calling: Mutually.Worker.start_link(arg)
      # {Mutually.Worker, arg},
      # Start to serve requests, typically the last entry
      MutuallyWeb.Endpoint,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mutually.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MutuallyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
