defmodule IceBear.Telegram.Client do
  alias Finch.Response
  @api_base_uri "https://api.telegram.org"
  @default_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]
  @pool_size 2

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       @api_base_uri => [size: @pool_size]
     }}
  end

  def get_me do
    :get
    |> Finch.build("#{@api_base_uri}/bot#{fetch_token()}/getMe", @default_headers, nil)
    |> Finch.request(__MODULE__)
    |> parse_response()
  end

  def get_updates do
    :get
    |> Finch.build("#{@api_base_uri}/bot#{fetch_token()}/getUpdates", @default_headers, nil)
    |> Finch.request(__MODULE__)
    |> parse_response()
  end

  def send_message(chat_id, text) do
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
  end

  defp fetch_token, do: Application.fetch_env!(:ice_bear, :bot_token)

  defp parse_response({:ok, %Response{body: body}}), do: body |> Jason.decode!()

  defp parse_response({:error, response}), do: response
end
