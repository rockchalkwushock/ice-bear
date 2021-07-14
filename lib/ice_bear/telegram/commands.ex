defmodule IceBear.Telegram.Commands do
  @moduledoc """
  Module represents all the commands that Ice Bear can except and act on
  that are built into his config on Telegram.

  Commands:
  - /create
  - /delete
  - /read
  - /update
  """
  require Logger

  def command([:create, opts]),
    do: Logger.info("----> IceBear.Telegram.Commands.command([:create, #{inspect(opts)}])")

  def command([:delete, opts]),
    do: Logger.info("----> IceBear.Telegram.Commands.command([:delete, #{inspect(opts)}])")

  def command([:read, opts]),
    do: Logger.info("----> IceBear.Telegram.Commands.command([:read, #{inspect(opts)}])")

  def command([:update, opts]),
    do: Logger.info("----> IceBear.Telegram.Commands.command([:update, #{inspect(opts)}])")
end
