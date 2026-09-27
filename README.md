# Nzyme's (Unofficial) Docker Images

Unofficial Docker images for **Nzyme nodes** and **taps**, providing a streamlined, dynamic, and secure way to deploy Nzyme.

## Features

* **Platform Support**: Built on Ubuntu Server 24.04 and supports `linux/amd64`.
* **Dynamic Configuration**: Configure at deploy-time using `nzyme{-tap}.conf.template` and environment variables. This decouples configuration from the image, ensuring compatibility with different Nzyme versions.
* **Enhanced Security**: Includes a dedicated `nzyme` user to prevent the container from running as root.
* **Deploy-time setup**: Entrypoints render configuration and start the node, migration job, or tap. An NTP server is configured for Nzyme; the images do not run a time-sync service.



## Images

You can pull the pre-built images from [Docker Hub](https://hub.docker.com/u/randomguyoninternet) or build them yourself. All configuration is driven by the `*.template` files located in the `examples` folder.

### `nzyme-node`
Install everything you need to run Nzyme Node. The start up script (run_nzyme_node.sh) script handles core configuration logic, sets Java options via `NZYME_JAVA_OPTS`, and assigns a `node_id`.

Mount a *nzyme.conf.template* to */etc/nzyme/nzyme.conf.template* to set configuration at deploy. See `examples/nzyme.conf.template` for an example.

### `nzyme-node-migration`
Install everything you need to run Nzyme Node migrations. The start up script (run_nzyme_node_migration.sh) does everything the `nzyme-node` image does, but with the addition of running the migration job. Once the job has completed, the container will exit. The idea of the image is to seperate any jobs from running the main application.

Mount a *nzyme.conf.template* to */etc/nzyme/nzyme.conf.template* to set configuration at deploy. See `examples/nzyme.conf.template` for an example.


### `nzyme-tap`
The `start.sh` script renders the tap template and requires `LEADER_SECRET`. If `/etc/nzyme/nzyme-tap-config` exists, it appends the hardware-specific adapter settings. Certificate verification is enabled by default; configure a trusted certificate for normal deployments.

Mount `examples/nzyme-tap.conf.template` at `/etc/nzyme/nzyme-tap.conf.template`, and mount a generated adapter file at `/etc/nzyme/nzyme-tap-config` when capturing traffic.

## Getting Started

### Prerequisites
* [Docker](https://docs.docker.com/get-docker/)
* [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

### Building the Images
Images are built using `docker buildx bake -f docker-bake.hcl`. The version is determined by `VERSION`. **Only alpha.17 is currently verified and enabled.** Newer versions, including alpha.18 and alpha.19, remain out of scope until upstream publishes packages and their node, tap, and migration behavior can be verified.

To build all three alpha.17 images:
```bash
VERSION=17 docker buildx bake -f docker-bake.hcl nzyme_node_v2 nzyme_node_migration_v2 nzyme_tap_v2
```

## Example

The repository-root `docker-compose.yaml` uses the templates in `examples/` and image tag `v2a17`. To use another published tag, update all three image references together (node, migration, and tap).

1. Copy `.env.example` to `.env` and replace `POSTGRES_PASSWORD` with a strong value. `.env` is ignored by Git. Never commit a real tap secret. Passwords containing URI-reserved characters need URL encoding in the node's database URL template.
2. Start PostgreSQL: `docker compose up -d postgres`. Check readiness with `docker compose ps`.
3. Run migrations **for the same image version as the node**, and wait for a successful exit: `docker compose up --exit-code-from nzyme-node-migration nzyme-node-migration`. Stop if it exits nonzero; rerun migrations before starting a newly upgraded node.
4. Start the node: `docker compose up -d nzyme-node`. Open `https://127.0.0.1:22900` (the example uses HTTPS). Register a tap and place its generated secret in `.env` as `LEADER_SECRET`.
5. Generate a host-specific adapter config with `./generate_tap_conf.sh v2a17`, copying only the configuration output to the ignored root-level `nzyme-tap-adapter` file. Then start the tap: `docker compose up -d nzyme-tap`. The tap uses host networking, so set `LEADER_URL` in `.env` to an address reachable *from the tap host* if it runs elsewhere. Provide a trusted certificate; for a trusted local demo with a self-signed certificate only, set `ACCEPT_INSECURE_CERTS=true` explicitly.

Use `docker compose logs` to inspect container output. The node's application logs may also be written under `/var/log/nzyme` by its package configuration.

## Contribution

Feel free to open an issue or submit a pull request if you find a bug or have a suggestion for an improvement!
