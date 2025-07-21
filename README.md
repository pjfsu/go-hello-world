# go-hello-world

A minimal “Hello World” application in Go—built and packaged **entirely** in containers using a multi-stage Containerfile. The runtime image is pushed automatically via GitHub Actions.

---

## Table of Contents

- [Motivation](#motivation)  
- [Overview](#overview)  
- [Repository Layout](#repository-layout)  
- [Building & Pushing the Runtime Image](#building--pushing-the-runtime-image)  
- [Demo](#demo)  
- [License](#license)  

---

## Motivation

I created this project because I wanted to:

- Experiment with the Go toolchain **only** via containers (see `app/mod.sh`).  
- Learn and demonstrate a **multi-stage build** pattern in Containerfile (builder → runtime).  
- Automate building **and** pushing the final runtime image using GitHub Actions.  

---

## Overview

- **Language:** Go 1.24  
- **Container Base Images:**  
  - Builder: `docker.io/golang:1.24`  
  - Runtime: `alpine:3.22`  
- **Output:**  
  - A lean runtime image (`pjfsu/go-hello-world-runtime:latest`) containing a single binary that prints `Hello World!`.  

---

## Repository Layout

```bash
.
├── app
│   ├── app.go              # Hello World Go source
│   ├── go.mod              # Module definition
│   ├── go.sum              # Dependency checksums
│   ├── Containerfile       # Multi-stage builder → runtime
│   └── mod.sh              # Init & tidy Go modules via container
├── .github
│   └── workflows
│       └── build_push.yml  # GH Actions: build & push runtime image
├── LICENSE                 # GPLv3
└── README.md               # This documentation
```

---

## Building & Pushing the Runtime Image

This project’s GitHub Action (`.github/workflows/build_push.yml`) will:

1. Log in to Docker Hub using repository secrets `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`.  
2. Build only the `runtime` stage from `app/Containerfile`.  
3. Push the image to `docker.io/pjfsu/go-hello-world-runtime:latest`.  

---

## Demo

```bash
user@localhost:~$ podman run --rm go-hello-world-runtime:latest 
Hello World!
user@localhost:~$ podman images docker.io/pjfsu/go-hello-world-runtime:latest --format '{{.Size}}'
10.8 MB
```

---

## License

This project is licensed under the **GPLv3**. See the [LICENSE](LICENSE) file for details.  

---

## EOR (End Of Repository)

### Thank you very much for visiting this repository!
### Muchas gracias por visitar este repositorio!
### Moitas grazas por visitar este repositorio!
