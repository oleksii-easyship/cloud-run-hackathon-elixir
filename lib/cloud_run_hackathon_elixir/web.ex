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

    action_disp = :rand.uniform(50)

    res =
      cond do
        action_disp <= 10 ->
          "T"

        action_disp > 40 ->
          Enum.random(["R", "L"])

        true ->
          "F"
      end

    send_resp(conn, 200, res)
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
