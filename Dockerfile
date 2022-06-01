FROM elixir:1.13.2-alpine as builder
WORKDIR /app
ENV MIX_ENV=prod

RUN mix local.hex --force && \
  mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get
COPY lib lib

RUN mix compile
RUN mix release

FROM alpine:3
RUN apk add --no-cache --update libgcc libstdc++ ncurses-libs
WORKDIR /app
RUN chown nobody:nobody /app
USER nobody:nobody
COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/cloud_run_hackathon_elixir/ .
CMD ["/app/bin/cloud_run_hackathon_elixir", "start"]
