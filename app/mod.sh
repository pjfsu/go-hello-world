#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly MODULE_PATH="github.com/pjfsu/${APP_NAME}"
readonly GO_IMAGE="docker.io/golang:1.24"

[ ! -f go.mod ] && \
	podman run \
	--rm \
	-v "${PWD}:/app:Z" \
	-w /app "${GO_IMAGE}" \
	go mod init "${MODULE_PATH}"

[ ! -f go.sum ] && \
	podman run \
	--rm \
	-v "${PWD}:/app:Z" \
	-w /app "${GO_IMAGE}" \
	go mod tidy

# touch go.sum if still missing (std-lib only)
[ ! -f go.sum ] && touch go.sum
