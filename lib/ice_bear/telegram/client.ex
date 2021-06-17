defmodule IceBear.Telegram.Client do
  @api_base_uri "https://api.telegram.org"
  @pool_size 2

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       @api_base_uri => [size: @pool_size]
     }}
  end
end
