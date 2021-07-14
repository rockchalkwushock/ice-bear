defmodule IceBear.Telegram.Commands do
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
