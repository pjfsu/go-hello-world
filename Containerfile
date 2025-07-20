# BUILDER
FROM docker.io/golang:1.24 AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY main.go ./
RUN go build -o hello-world ./

# RUNTIME
FROM alpine:3.22 AS runtime

RUN addgroup -S appgroup \
	&& adduser -S appuser -G appgroup

COPY --from=builder --chown=appuser:appgroup /app/hello-world /usr/local/bin/hello-world

USER appuser

ENTRYPOINT ["hello-world"]
