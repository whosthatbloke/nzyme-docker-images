# Nzyme's (Unofficial) Docker Images

Unofficial Docker images for **Nzyme nodes** and **taps**, providing a streamlined, dynamic, and secure way to deploy Nzyme.

## Features

* **Platform Support**: Built on Ubuntu Server 24.04 and supports `linux/amd64`.
* **Dynamic Configuration**: Configure at deploy-time using `nzyme{-tap}.conf.template` and environment variables. This decouples configuration from the image, ensuring compatibility with different Nzyme versions.
* **Enhanced Security**: Includes a dedicated `nzyme` user to prevent the container from running as root.
* **Effortless Setup**: The images automate configuration and time synchronization, making them quick and easy to get up and running.



## Images

You can pull the pre-built images from [Docker Hub](https://hub.docker.com/u/randomguyoninternet) or build them yourself. All configuration is driven by the `*.template` files located in the `examples` folder.

### `nzyme-node`
Install everything you need to run Nzyme Node. The start up script (run_nzyme_node.sh) script handles core configuration logic, sets Java options via `NZYME_JAVA_OPTS`, and assigns a `node_id`.

Mount a *nzyme.conf.template* to */etc/nzyme/nzyme.conf.template* to set configuration at deploy. See `examples/nzyme.conf.template` for an example.

### `nzyme-node-migration`
Install everything you need to run Nzyme Node migrations. The start up script (run_nzyme_node_migration.sh) does everything the `nzyme-node` image does, but with the addition of running the migration job. Once the job has completed, the container will exit. The idea of the image is to seperate any jobs from running the main application.

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

## Example

You can find example `docker-compose.yaml` file and configuration templates in the `examples/` folder. The example tap and node configuration have been tested with the `v2a17` images. 

You can generate your own `nzyme-tap-adapter` configuration file by running the provided `generate_tap_conf.sh` script. SImply copy/pipe the output the `nzyme-tap-adapter` at the project level (*this file is ignored git*),

First, setup postgres by running `docker compose up -d postgres`. Once postgres is up, run `docker compose up -d nzyme-node-migration` This will setup our initial (and future) migrations. Next, bring up nzyme-node with `docker comcpose up -d nzyme-node`. Once nzyme is up and running at `http://localhost:22900`, setup a tap and grab it's secret; then update the `LEADER_SECRET` environment variable in the compose file. Then run `docker compose up -d nzyme-tap`. You can run `docker compose logs` to see what's happening in the background.

You have sucessfully deployed nzyme!

## Contribution

Feel free to open an issue or submit a pull request if you find a bug or have a suggestion for an improvement!
