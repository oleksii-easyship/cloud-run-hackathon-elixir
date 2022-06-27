defmodule CloudRunHackathonElixir.Web do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  alias CloudRunHackathonElixir.Map

  get "/" do
    IO.puts("#{conn.method} - 200 \n")
    send_resp(conn, 200, "Let the game begin!")
  end

  post "/" do
    # Prints JSON POST body
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    IO.puts("#{conn.method} - 200 \n #{body}")

    try do
      res =
        Map.parse_body(body)
        |> Map.next_move()

        #TEMP
      send_resp(conn, 200, Enum.random(["T", "L", "R", "F"]))
    rescue
      e ->
        IO.puts("ERROR")
        IO.inspect(e)
        send_resp(conn, 200, Enum.random(["T", "L", "R", "F"]))
    end
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
