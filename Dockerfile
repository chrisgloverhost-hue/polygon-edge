# ─── Stage 1: Build ───────────────────────────────────────────────────────────
FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git bash

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o polygon-edge \
    -ldflags="-X 'github.com/0xPolygon/polygon-edge/versioning.Version=v1.0.0' \
              -X 'github.com/0xPolygon/polygon-edge/versioning.Branch=main'" \
    main.go

# ─── Stage 2: Runtime ─────────────────────────────────────────────────────────
FROM alpine:3.18

RUN apk add --no-cache ca-certificates bash

WORKDIR /app

# Copy binary
COPY --from=builder /app/polygon-edge ./polygon-edge

# Copy shared chain genesis (validator data lives in the mounted /app/data volume)
COPY genesis.json ./genesis.json

# Copy startup script
COPY start-validator.sh ./start-validator.sh
RUN chmod +x ./start-validator.sh ./polygon-edge

# Railway injects PORT; default to 8080 for local Docker runs
EXPOSE 8080

ENTRYPOINT ["bash", "start-validator.sh"]
