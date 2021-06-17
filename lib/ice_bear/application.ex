defmodule IceBear.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      IceBear.Repo,
      # Start the Telemetry supervisor
      IceBearWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: IceBear.PubSub},
      # Start the Endpoint (http/https)
      IceBearWeb.Endpoint,
      # Start Finch Connection Pool.
      IceBear.Telegram.Client.child_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IceBear.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IceBearWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
