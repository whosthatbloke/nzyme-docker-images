# Nzyme Unofficial Docker Images 🧪

Unofficial Docker images for **Nzyme nodes** and **taps**, providing a streamlined, dynamic, and secure way to deploy Nzyme.

## Features

* **Platform Support**: Built on Ubuntu Server 24.04 and supports `linux/amd64`.
* **Dynamic Configuration**: Configure at deploy-time using `nzyme{-tap}.conf.template` and environment variables. This decouples configuration from the image, ensuring compatibility with different Nzyme versions.
* **Enhanced Security**: Includes a dedicated `nzyme` user to prevent the container from running as root.
* **Effortless Setup**: The images automate configuration and time synchronization, making them quick and easy to get up and running.



## Images

You can pull the pre-built images from [Docker Hub](https://hub.docker.com/u/randomguyoninternet) or build them yourself. All configuration is driven by the `*.template` files located in the `examples` folder.

### `nzyme-node`
The `start.sh` script handles core configuration logic, sets Java options via `NZYME_JAVA_OPTS`, assigns a `node_id`, and runs database migrations (enabled by default).

Mount a *nzyme.conf.template* to */etc/nzyme/nzyme.conf.template* to set configuration at deploy. See `examples/nzyme.conf.template` for an example.

### `nzyme-tap`
The `start.sh` script manages configuration and validates that the `LEADER_SECRET` environment variable is set. Custom adapter configurations are read from `/etc/nzyme/nzyme-tap-config` and automatically appended to the main configuration, allowing you to separate hardware-specific settings from the core Nzyme-Tap configuration.

Mount a *nzyme.conf.template* to */etc/nzyme/nzyme.conf.template* to set configuration at deploy. See `examples/nzyme.conf.template` for an example.

/etc/nzyme/nzyme-tap.conf.template

## Getting Started

### Prerequisites
* [Docker](https://docs.docker.com/get-docker/)
* [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

### Building the Images
Images are built using `docker buildx bake`. The version is determined by the `VERSION` environment variable.

To build `nzyme-node` version 17:
```bash
VERSION=17 docker buildx bake nzyme_node_v2
```

## Usage Examples

You can find example docker-compose.yaml files and configuration templates in the examples folder.

A generate_tap_conf.sh script is provided to help you quickly create a custom adapter configuration file.

## Contribution

Feel free to open an issue or submit a pull request if you find a bug or have a suggestion for an improvement!