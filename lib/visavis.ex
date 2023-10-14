defmodule VisaVis do
  @moduledoc """
  `VisaVis` is a simple chat app.
  """
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: VisaVis.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.VisaVis
      )
    ]

    opts = [strategy: :one_for_one, name: VisaVis.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
        [
          {"/ws/[...]", VisaVis.SocketHandler, []},
          {:_, Plug.Cowboy.Handler, {VisaVis.Router, []}}
        ]
      }
    ]
  end
end
