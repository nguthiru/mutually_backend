# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mutually,
  ecto_repos: [Mutually.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :mutually, MutuallyWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: MutuallyWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Mutually.PubSub,
  live_view: [signing_salt: "aFocegSo"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :mutually, Mutually.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :mutually, MutuallyWeb.Accounts.Guardian,
  issuer: "mutually",
  secret_key: "DhPQy8HFN8F3CCoXPIgOR6b7M7xn+g8khMLm6UlJeWe1A7Llz8m4hEAT/gwqCIqa",
  error_handler: MutuallyWeb.Accounts.GuardianErrorHandler
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
