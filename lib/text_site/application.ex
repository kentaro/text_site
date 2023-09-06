defmodule TextSite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ThousandIsland, port: 23, handler_module: TextSite}
    ]

    opts = [strategy: :one_for_one, name: TextSite.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
