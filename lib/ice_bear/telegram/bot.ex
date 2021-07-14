defmodule IceBear.Telegram.Bot do
  @moduledoc """
  Implementation details of Ice Bear.
  """
  use GenServer
  require Logger

  alias Phoenix.PubSub
  alias IceBear.Telegram.Client, as: Telegram
  import IceBear.Telegram.Commands, only: [command: 1]

  ######################
  # Client API
  ######################

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  ######################
  # GenServer Callbacks
  ######################

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
  def handle_info({:update, update}, state) do
    Logger.debug("----> IceBear.Telegram.Bot.handle_info/2")

    update |> parse_response() |> handle_message(state)

    {:noreply, state}
  end

  def handle_message({_id, command}, _state) when command === "/create",
    do: command([:create, %{}])

  def handle_message({_id, command}, _state) when command === "/delete",
    do: command([:delete, %{}])

  def handle_message({_id, command}, _state) when command === "/read",
    do: command([:read, %{}])

  def handle_message({_id, command}, _state) when command === "/update",
    do: command([:update, %{}])

  def handle_message({id, text}, _state),
    do: Telegram.send_message(id, "Huh? #{text} is not an option.")

  ##################
  # Module Utilities
  ##################

  defp parse_response(response) do
    Logger.info("Response: #{inspect(response)}")

    id = response["message"]["chat"]["id"]
    text = response["message"]["text"]

    {id, text}
  end
end
