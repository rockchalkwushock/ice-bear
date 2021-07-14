defmodule IceBear.Telegram.BotSupervisor do
  @moduledoc """
  Supervisor for managing the Bot and BotPolar GenServers.
  """
  use Supervisor
  require Logger

  ######################
  # Client API
  ######################

  def start_link(key) do
    Supervisor.start_link(__MODULE__, key)
  end

  ######################
  # Supervisor Callbacks
  ######################

  @impl true
  def init(key) do
    Logger.debug("----> IceBear.Telegram.BotSupervisor.init/1")

    children = [
      {IceBear.Telegram.Bot, key},
      {IceBear.Telegram.BotPolar, key}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
