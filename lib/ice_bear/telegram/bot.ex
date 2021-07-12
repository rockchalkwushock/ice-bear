defmodule IceBear.Telegram.Bot do
  @moduledoc """
  Implementation details of Ice Bear.
  """
  use GenServer
  require Logger

  alias Phoenix.PubSub
  alias IceBear.Telegram.Client, as: Telegram

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  @impl true
  def init(_opts) do
    Logger.debug("----> IceBear.Telegram.Bot.init/1")
    {:ok, %{"id" => id, "username" => username}} = Telegram.get_me()

    # Have Ice Bear subscribe to the message "ice_bear:<id>"
    PubSub.subscribe(IceBear.PubSub, "ice_bear:#{id}")

    state = %{
      id: id,
      username: username
    }

    {:ok, state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.debug("----> IceBear.Telegram.Bot.handle_info/2")
    Logger.info(inspect(msg))
    {:noreply, state}
  end
end
