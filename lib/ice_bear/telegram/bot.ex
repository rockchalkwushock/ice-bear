defmodule IceBear.Telegram.Bot do
  use GenServer
  require Logger

  alias IceBear.Telegram

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  @impl GenServer
  def init(_opts) do
    Logger.info("----> IceBear.Telegram.Bot.init/1")
    {:ok, %{"id" => id, "username" => username}} = Telegram.Client.get_me()

    Phoenix.PubSub.subscribe(IceBear.PubSub, "telegram_bot_update:#{id}")

    state = %{
      id: id,
      name: username
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_info({:update, update}, state) do
    Logger.info("----> IceBear.Telegram.Bot.handle_info/2")

    update
    |> deconstruct_response()
    |> handle_update(state)

    {:noreply, state}
  end

  def handle_update({_id, command}, _state) when command == "/create" do
    Logger.info("----> IceBear.Telegram.Bot.handle_update/2 [COMMAND: CREATE]")
  end

  def handle_update({_id, command}, _state) when command == "/read" do
    Logger.info("----> IceBear.Telegram.Bot.handle_update/2 [COMMAND: READ]")
  end

  def handle_update({_id, command}, _state) when command == "/update" do
    Logger.info("----> IceBear.Telegram.Bot.handle_update/2 [COMMAND: UPDATE]")
  end

  def handle_update({_id, command}, _state) when command == "/delete" do
    Logger.info("----> IceBear.Telegram.Bot.handle_update/2 [COMMAND: DELETE]")
  end

  def handle_update({id, text}, _state) do
    Logger.info("----> IceBear.Telegram.Bot.handle_update/2")
    Logger.info("Text: #{text}")
    Telegram.Client.send_message(id, "Huh?")
  end

  defp deconstruct_response(response) do
    Logger.info("Response #{inspect(response)}")

    %{
      "message" => %{
        "chat" => %{
          "id" => id
        },
        "text" => text
      }
    } = response

    {id, text}
  end
end
