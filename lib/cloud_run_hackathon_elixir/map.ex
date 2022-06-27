defmodule CloudRunHackathonElixir.Map do
  def parse_body(body_str) do
    json_body = Jason.decode!(body_str)

    %{
      "_links" => %{
        "self" => %{
          "href" => app_url
        }
      },
      "arena" => %{
        "dims" => [arena_width, arena_height],
        "state" => arena_state
      }
    } = json_body

    {{arena_width, arena_height}, arena_state, app_url}
  end

  def next_move({dims, state, me} = _arena_struct) do
    if can_hit(dims, state, me) do
      "T"
    else
      action_disp = :rand.uniform(50)

      if action_disp <= 35 do
        "F"
      else
        Enum.random(["R", "L"])
      end
    end
  end

  def find_me(state, me) do
    state[me] || raise "No place on board found!"
  end

  def can_hit(dims, state, me) do
    my_state = find_me(state, me)
    x = my_state["x"]
    y = my_state["y"]
    dir = my_state["direction"]

    hit_line_res = hit_line(dims, x, y, dir)

    others =
      state
      |> Enum.reduce([], fn {_url, %{"x" => other_x, "y" => other_y}}, list -> [{other_x, other_y} | list] end)

    IO.puts "TARGETS"
    IO.inspect others

    MapSet.intersection(MapSet.new(hit_line_res), MapSet.new(others)) != MapSet.new([])
  end

  defp hit_line(_bounds, x, y, "N") do
    [
      {x - 1, y},
      {x - 2, y},
      {x - 3, y}
    ]
    |> Enum.filter(fn {x, y} -> x >= 0 end)
  end

  defp hit_line({w, _h} = _bounds, x, y, "E") do
    [
      {x, y + 1},
      {x, y + 2},
      {x, y + 3}
    ]
    |> Enum.filter(fn {x, y} -> y <= w end)
  end

  defp hit_line({_w, h} = _bounds, x, y, "S") do
    [
      {x + 1, y},
      {x + 2, y},
      {x + 3, y}
    ]
    |> Enum.filter(fn {x, y} -> x <= h end)
  end

  defp hit_line(_bounds, x, y, "W") do
    [
      {x, y - 1},
      {x, y - 2},
      {x, y - 3}
    ]
    |> Enum.filter(fn {x, y} -> y >= 0 end)
  end
end
