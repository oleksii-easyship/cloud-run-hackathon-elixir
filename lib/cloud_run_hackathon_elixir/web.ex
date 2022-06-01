defmodule CloudRunHackathonElixir.Web do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    IO.puts("#{conn.method} - 200 \n")
    send_resp(conn, 200, "Let the game begin!")
  end

  post "/" do
    # Prints JSON POST body
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    IO.puts("#{conn.method} - 200 \n #{body}")

    moves = ['F', 'T', 'R', 'L']
    send_resp(conn, 200, Enum.random(moves))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
