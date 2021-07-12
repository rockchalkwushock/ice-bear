defmodule IceBear.Telegram.BotPolar do
  @moduledoc """
  Polling service for Ice Bear to listen and receive updates from Telegram.
  """
  use GenServer
  require Logger

  import IceBear.Telegram.Client, except: [send_message: 2]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  @impl true
  def init(_opts) do
    Logger.debug("----> IceBear.Telegram.BotPolar.init/1")
    {:ok, %{"id" => id, "username" => username}} = get_me()

    state = %{
      id: id,
      last_seen: -2,
      username: username
    }

    {:ok, state}
  end
end
