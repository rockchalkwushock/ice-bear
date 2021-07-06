defmodule IceBear.Telegram.BotPolar do
  @moduledoc """

  """
  use GenServer
  require Logger

  alias IceBear.Telegram

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  @impl GenServer
  def init(_opts) do
    Logger.info("----> IceBear.Telegram.BotPolar.init/1")
    {:ok, %{"id" => id, "username" => username}} = Telegram.Client.get_me()

    state = %{
      id: id,
      last_seen: -2,
      name: username
    }

    next_loop()
    {:ok, state}
  end

  @impl GenServer
  def handle_info(:start, %{last_seen: last_seen} = state) do
    Logger.info("----> IceBear.Telegram.BotPolar.handle_info/2")

    state =
      case Telegram.Client.get_updates(last_seen) do
        {:ok, []} ->
          state

        {:ok, updates} ->
          last_seen =
            Enum.map(updates, fn update ->
              Phoenix.PubSub.broadcast!(
                IceBear.PubSub,
                "telegram_bot_update:#{state.id}",
                {:update, update}
              )

              update["update_id"]
            end)
            |> Enum.max(fn -> last_seen end)

          %{state | last_seen: last_seen}

        other ->
          Logger.error("Unexpected response getting updates.", response: other)
          :timer.sleep(2000)
          state
      end

    next_loop()
    {:noreply, state}
  end

  defp next_loop do
    Process.send_after(self(), :start, 0)
  end
end
