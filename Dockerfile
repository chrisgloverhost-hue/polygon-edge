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

# Copy chain-wide genesis config
COPY genesis.json ./genesis.json

# Create empty data directories; Railway volumes will mount at runtime
RUN mkdir -p /data/validator1 /data/validator2 /data/validator3 /data/validator4

# Copy startup script
COPY start-railway.sh ./start-railway.sh
RUN chmod +x ./start-railway.sh ./polygon-edge

# Railway injects PORT; default to 8080 for local Docker runs
EXPOSE 8080

ENTRYPOINT ["./polygon-edge"]
