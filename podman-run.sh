#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# CONSTANTS
readonly HUB_USER="localhost"
readonly IMAGE_VERSION="1.0.0"
readonly APP_NAME="go-hello-world"
readonly MODULE_PATH="github.com/pjfsu/${APP_NAME}"

readonly GO_IMAGE="docker.io/golang:1.20-alpine"
readonly BUILDER_IMAGE="${HUB_USER}/${APP_NAME}-builder:${IMAGE_VERSION}"
readonly RUNTIME_IMAGE="${HUB_USER}/${APP_NAME}-runtime:${IMAGE_VERSION}"

# MAIN
main() {
	ensure_go_md
	ensure_go_sum

	build_stage builder "${BUILDER_IMAGE}"
	build_stage runtime "${RUNTIME_IMAGE}"

	run_runtime
}

# HELPERS
log() { 
	printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"
}

error() { 
	log "ERROR: $*" >&2
       	exit 1
}

ensure_go_md() {
	if [ ! -f go.mod ]; then
		log "Initializing Go module ..."
		podman run --rm -v "${PWD}:/app:Z" -w /app "${GO_IMAGE}" \
			go mod init "{MODULE_PATH}"
	fi
}

ensure_go_sum() {
	if [ ! -f go.sum ]; then
		log "Tidying Go modules (may create go.sum) ..."
		podman run --rm -v "${PWD}:/app:Z" -w /app "${GO_IMAGE}" \
			go mod tidy
	fi

	# Fix: touch go.sum if still missing (std-lib only)
	if [ ! -f go.sum ]; then
		log "Creating empty go.sum ..."
		touch go.sum
	fi
}

build_stage() {
	local stage="${1}" image="${2}"
	if podman image exists "${image}"; then
		log "Skipping build of '${stage}', image '${image}' exists."
	else
		log "Building '${stage}' stage ---> '${image}' ..."
		podman build --target "${stage}" -t "${image}"
	fi
}

run_runtime() {
	log "Running container from image '${RUNTIME_IMAGE}' ..."
	podman run --rm "${RUNTIME_IMAGE}"
}

# START SCRIPT
main "${@}"
