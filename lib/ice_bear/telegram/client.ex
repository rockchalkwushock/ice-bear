defmodule IceBear.Telegram.Client do
  @moduledoc """
  IceBear.Telegram.Client

  The HTTP Client/Wrapper for the Telegram Bot API
  that Ice Bear makes use of. I have no need for a
  full-fledged client like Nadia, Telegex, etc for
  this project so this is a very minimal implementation
  of the aforementioned projects.
  """
  alias Finch.Response
  require Logger

  @api_base_uri "https://api.telegram.org"
  @default_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]
  @pool_size 2

  def child_spec do
    Logger.debug("----> Finch Connection Pool being established.")

    pool =
      {Finch,
       name: __MODULE__,
       pools: %{
         @api_base_uri => [size: @pool_size]
       }}

    Logger.debug("----> Finch Connection Pool established: #{inspect(pool)}")
    pool
  end

  def get_me do
    Logger.debug("----> get_me/0")

    :get
    |> Finch.build("#{@api_base_uri}/bot#{fetch_token()}/getMe", @default_headers, nil)
    |> Finch.request(__MODULE__)
    |> parse_response()
    |> process_response()
  end

  def get_updates(last_seen) do
    Logger.debug("----> get_updates/1")
    Logger.info("Last seen: #{last_seen}")

    :get
    |> Finch.build(
      "#{@api_base_uri}/bot#{fetch_token()}/getUpdates",
      @default_headers,
      Jason.encode!(%{
        "offset" => last_seen + 1,
        "timeout" => 30
      })
    )
    |> Finch.request(__MODULE__)
    |> parse_response()
    |> process_response()
  end

  def send_message(chat_id, text) do
    Logger.debug("----> send_message/2")

    :post
    |> Finch.build(
      "#{@api_base_uri}/bot#{fetch_token()}/sendMessage",
      @default_headers,
      Jason.encode!(%{
        "chat_id" => chat_id,
        "text" => text
      })
    )
    |> Finch.request(__MODULE__)
    |> parse_response()
    |> process_response()
  end

  defp fetch_token, do: Application.fetch_env!(:ice_bear, :bot_token)

  defp parse_response({:ok, %Response{body: body}}), do: body |> Jason.decode!()

  defp parse_response({:error, response}), do: response

  defp process_response(%{"ok" => true, "result" => result}), do: {:ok, result}

  defp process_response(%Mint.TransportError{reason: reason}), do: reason
end
