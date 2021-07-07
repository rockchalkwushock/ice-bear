defmodule IceBear.Telegram.Client do
  @moduledoc """
  IceBear.Telegram.Client

  The HTTP Client/Wrapper for the Telegram Bot API
  that IceBear makes use of. I have no need for a
  full-fledged cleint like Nadia, Telegex, etc for
  this project so this is a very minimal implementation
  of the aformentioned projects.
  """
  require Logger

  @api_base_uri "https://api.telegram.org"
  @pool_size 2

  def child_spec do
    Logger.debug("----> Finch Connection Pool is being established.")

    pool =
      {Finch,
       name: __MODULE__,
       pools: %{
         @api_base_uri => [size: @pool_size]
       }}

    Logger.debug("----> Finch Connection Pool established: #{inspect(pool)}")

    pool
  end
end
