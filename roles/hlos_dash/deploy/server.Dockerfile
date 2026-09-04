FROM golang:1.24-bookworm AS build
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /src/server
COPY server/go.mod server/go.sum ./
RUN go mod download
COPY server/ ./
RUN CGO_ENABLED=1 go build -o /out/hlos-dash-server .
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates make docker.io git openssh-client bash && rm -rf /var/lib/apt/lists/*
COPY --from=build /out/hlos-dash-server /usr/local/bin/hlos-dash-server
EXPOSE 8081
ENTRYPOINT ["/usr/local/bin/hlos-dash-server"]
CMD ["serve"]
