defmodule IceBear.Telegram.Bot do
  @moduledoc """
  Implementation details of Ice Bear.
  """
  use GenServer
  require Logger

  alias IceBear.Telegram.Client, as: Telegram

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  @impl true
  def init(_opts) do
    Logger.debug("----> IceBear.Telegram.Bot.init/1")
    {:ok, %{"id" => id, "username" => username}} = Telegram.get_me()

    state = %{
      id: id,
      username: username
    }

    {:ok, state}
  end
end
