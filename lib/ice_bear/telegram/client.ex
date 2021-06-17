defmodule IceBear.Telegram.Client do
  alias Finch.Response
  @api_base_uri "https://api.telegram.org"
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
    |> Finch.build("#{@api_base_uri}/bot#{fetch_token()}/getMe", [], nil)
    |> Finch.request(__MODULE__)
    |> parse_response()
  end

  defp fetch_token, do: Application.fetch_env!(:ice_bear, :bot_token)

  defp parse_response({:ok, %Response{body: body}}), do: body |> Jason.decode!()

  defp parse_response({:error, response}), do: response
end
