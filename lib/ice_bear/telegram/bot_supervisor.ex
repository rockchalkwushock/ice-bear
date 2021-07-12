defmodule IceBear.Telegram.BotSupervisor do
  use Supervisor

  def start_link(key) do
    Supervisor.start_link(__MODULE__, key)
  end

  @impl true
  def init(key) do
    children = [
      {IceBear.Telegram.Bot, key},
      {IceBear.Telegram.BotPolar, key}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
