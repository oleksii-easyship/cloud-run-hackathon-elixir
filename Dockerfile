FROM elixir:1.13.2-alpine
WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get
COPY lib lib

RUN mix compile

CMD ["mix", "run", "--no-halt"]
