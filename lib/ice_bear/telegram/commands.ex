defmodule IceBear.Telegram.Commands do
  @moduledoc """
  IceBear.Telegram.Commands

  Holds all the available commands my wife and I can
  send to Ice Bear and the actions those commands will
  dispatch when Ice Bear hears them.
  """

  def command([:create, _opts]), do: nil
  def command([:get, _opts]), do: nil
  def command([:get_all, _opts]), do: nil
  def command([:update, _opts]), do: nil
  def command([:delete, _opts]), do: nil
end
