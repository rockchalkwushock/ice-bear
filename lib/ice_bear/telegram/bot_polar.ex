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

    next_loop()
    {:ok, state}
  end

  @impl true
  def handle_info(:start, %{last_seen: last_seen} = state) do
    Logger.debug("----> IceBear.Telegram.BotPolar.handle_info/2")

    state =
      case get_updates(last_seen) do
        {:ok, []} ->
          state

        {:ok, updates} ->
          last_seen =
            Enum.map(updates, fn update ->
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
