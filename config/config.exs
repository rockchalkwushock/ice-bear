# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ice_bear,
  ecto_repos: [IceBear.Repo]

# Configures the endpoint
config :ice_bear, IceBearWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jrP9UBW680kh01/Y5QfK4hL+VgRVX6lKZBAY0n5gYveTQd8SsXnZgODdSRGe0TrW",
  render_errors: [view: IceBearWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: IceBear.PubSub,
  live_view: [signing_salt: "ryY7HrfM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
