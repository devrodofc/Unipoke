
defmodule Unipoke.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: UnipokeFinch},
      Unipoke.Consumer
    ]

    opts = [strategy: :one_for_one, name: Unipoke.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
