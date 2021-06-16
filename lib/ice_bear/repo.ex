defmodule IceBear.Repo do
  use Ecto.Repo,
    otp_app: :ice_bear,
    adapter: Ecto.Adapters.Postgres
end
