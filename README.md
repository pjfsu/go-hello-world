# go-hello-world

A minimal “Hello World” application in Go, packaged with a multi-stage Containerfile for lean, reproducible builds.

## Table of Contents

- [Overview](#overview)  
- [Repository Structure](#repository-structure)  
- [Prerequisites](#prerequisites)  
- [Quick Start](#quick-start)  
- [Building & Running](#building--running)  
  - [Using the Helper Script](#using-the-helper-script)  
  - [Manual Container Builds](#manual-container-builds)  
- [Customizing](#customizing)  
- [Files Description](#files-description)  
- [License](#license)  

## Overview

This project demonstrates:

- A simple Go program (`main.go`) that prints “Hello World!”  
- A multi‐stage Containerfile for building with `golang:1.24` and running on `alpine:3.22`  
- A helper shell script (`main.sh`) that automates module initialization, image builds, and container runs  

## Repository Structure

```
.
├── Containerfile     # Multi-stage build definition
├── LICENSE           # GPLv3 license
├── go.mod            # Go module definition
├── go.sum            # Checksums for third-party modules
├── main.go           # Hello World Go source
├── main.sh           # Helper script to build & run via Podman
└── README.md         # This documentation
```

## Prerequisites

- Podman (or Docker) installed and configured  
- Bash (for `main.sh`)  
- Internet access to pull the `golang` and `alpine` base images  

## Quick Start

Clone the repo and execute the helper script:

```bash
git clone https://github.com/pjfsu/go-hello-world.git
cd go-hello-world
chmod +x main.sh
./main.sh
```

You should see:

```
[12:34:56] Initializing Go module ...
[12:34:57] Tidying Go modules (may create go.sum) ...
[12:34:58] Building 'builder' stage → 'localhost/go-hello-world-builder:1.0.0' ...
[12:35:10] Building 'runtime' stage → 'localhost/go-hello-world-runtime:1.0.0' ...
[12:35:15] Running container from image 'localhost/go-hello-world-runtime:1.0.0' ...
Hello World!
```

## Building & Running

### Using the Helper Script

The `main.sh` script:

1. Initializes `go.mod` if missing  
2. Runs `go mod tidy` (and touches an empty `go.sum` if none is generated)  
3. Builds the builder and runtime images if they don’t already exist  
4. Launches the runtime container and prints “Hello World!”  

Run:
```bash
./main.sh
```

### Manual Container Builds

1. Build the **builder** stage:
   ```bash
   podman build --target builder \
     -t localhost/go-hello-world-builder:1.0.0 .
   ```
2. Build the **runtime** stage:
   ```bash
   podman build --target runtime \
     -t localhost/go-hello-world-runtime:1.0.0 .
   ```
3. Run the container:
   ```bash
   podman run --rm localhost/go-hello-world-runtime:1.0.0
   ```

## Files Description

- **Containerfile**: Multi‐stage build; first compiles Go code, then packages a static binary in Alpine.  
- **main.go**: Prints “Hello World!” using the standard library.  
- **main.sh**: Automates module init, dependency management, image builds, and container runs.  
- **go.mod/go.sum**: Go module metadata and checksum lockfile.  
- **LICENSE**: GPLv3 license granted by the project author.

## License

This project is licensed under the GPLv3 License. See the [LICENSE](LICENSE) file for details.
