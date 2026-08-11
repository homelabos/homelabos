# Repository Guidelines

## Overview

HomelabOS is an Ansible-based infrastructure automation system that deploys and manages 100+ self-hosted services (Nextcloud, Plex, Jellyfin, GitLab, etc.) on a single server. It provides automated backups, HTTPS via LetsEncrypt, optional Tor hidden services, and an optional cloud bastion server with WireGuard VPN.

## Architecture

### Core Components

1. **Go CLI Tool** (`main.go`, `cmd/`, `services/`)
   - Generates configuration templates and documentation from service definitions.
   - `homelabos package` — Generates `group_vars/all`, `docs/index.md`, and `config.yml.j2` from role metadata.
   - `homelabos test` — Runs deployment tests on services.
   - Service metadata lives in `roles/*/service.yml` files.

2. **Ansible Playbooks** (`playbook.*.yml`)
   - `playbook.homelabos.yml` — Main deployment playbook.
   - `playbook.config.yml` — Interactive configuration wizard (prompts for domain, IP, credentials).
   - `playbook.restart.yml` / `playbook.stop.yml` / `playbook.remove.yml` — Service lifecycle management.
   - `playbook.terraform.yml` — Cloud infrastructure provisioning.

3. **Ansible Roles** (`roles/`)
   - **Core roles** (prefixed with `homelabos_`): `homelabos_common` (base setup), `homelabos_deploy` (service orchestration), `homelabos_config`, `homelabos_wireguard`, `homelabos_port_forwarding`.
   - **Service roles** (160+ directories): each contains `tasks/main.yml`, `templates/docker-compose.*.yml.j2`, and `service.yml` metadata. Services are deployed as systemd units running docker-compose.

4. **Configuration System** (`settings/`)
   - `config.yml` — Main config (domain, IP, service enable flags, service-specific settings).
   - `vault.yml` — Encrypted secrets (Ansible vault, passwords, API keys).
   - `additional_services_config.yml` — Custom/additional service configurations.
   - `config.yml.blank` — Seed template; `group_vars/all` is generated from role metadata.
   - Settings can be synced to git via `git_sync.sh`.

5. **Docker Infrastructure**
   - All services run in Docker containers orchestrated by docker-compose.
   - Traefik reverse proxy handles routing and automatic HTTPS.
   - Each service gets a systemd unit at `/etc/systemd/system/<service>.service`.
   - Data stored at `{{ volumes_root }}` (default: `/var/homelabos`).

### Deployment Flow

1. `make config` → generates/updates configuration files, encrypts vault.
2. `make` / `make deploy` → builds Docker image, runs `homelabos package`, then executes `playbook.homelabos.yml` via `docker_helper.sh`. Playbook order: TOR → common setup → bastion → docs → service deployment.

### Service Role Anatomy

```
roles/<service>/
├── service.yml              # Metadata: description, version, port, category
├── additional_configs.yml   # Extra config parameters (optional)
├── defaults/main.yml        # Default variables (optional)
├── tasks/main.yml           # Deployment tasks
├── templates/
│   └── docker-compose.<service>.yml.j2
└── docs.md                  # Service documentation
```

**tasks/main.yml pattern:**
```yaml
- name: Setup {{service_item}}
  include: includes/setup.yml

# Service-specific tasks (create dirs, generate passwords, etc.)

- name: Start {{service_item}}
  include: includes/start.yml
```

**Traefik labels (`labels.j2`) are required in every docker-compose template.**

Every service template must end with the label include so Traefik can route to it:

```yaml
    networks:
      - traefik_network
{% include './labels.j2' %}
```

- The shared source of `labels.j2` is **`roles/homelabos_deploy/templates/labels.j2`**. It renders the per-service Traefik labels (loadbalancer port from `service.yml`, routing for the service domain, HTTPS/TLS via certresolver, and optional auth/Tor/sslip routes).
- It uses `service_item` plus the `port` from `service.yml`, so it works for every service without a per-service copy.
- Do **not** create or maintain a per-role `templates/labels.j2` for new services (only legacy roles like `immich`/`fileflows`/`invoiceplane`/`listmonk`/`paseo` carry their own copies; leave those alone). Changes to the standard labels belong in the shared `roles/homelabos_deploy/templates/labels.j2`.
- For services not exposed through Traefik (e.g. pure utilities), the sanity test requires either this include or `port: false` in `service.yml` — set `port: false` and omit the `traefik_network`/`labels.j2` block in that case.

### Available Variables in Service Templates

- `service_item`, `service_domain`, `domain`, `volumes_root`, `storage_dir`
- `default_username` / `default_password` — Admin credentials
- `https_only`, `auth`, `custom_domain`
- `tor_domain`, `tor_ssh_domain`
- `uid` / `gid`
- All service-specific config from `config.yml`

## HomelabOS Service Fixes
- Make durable service configuration fixes in the source templates under `install/roles/**/templates/` or shared template files.
- Redeploy from the templates after changing service configuration.
- Do not treat generated top-level service files such as `/var/homelabos/<service>/docker-compose.yml` as the source of truth.
- Direct generated-file edits are only acceptable as temporary emergency mitigation and must be followed by a matching template change and redeploy.

## Build, Test, and Development Commands

### Build and Deploy

```bash
make                        # Full build + deploy (same as make deploy)
make deploy                 # Full HomelabOS deployment
make config                 # Update/generate configuration files
make config_reset           # Reset all local settings (backs up to settings.bak)
make build                  # Build Docker images
make rebuild                # Force rebuild Docker image
```

### Single Service Operations

```bash
make update_one <service>   # Update and restart single service
make restart_one <service>  # Restart single service
make stop_one <service>     # Stop single service
make remove_one <service>   # Remove single service data
make reset_one <service>    # Stop, remove data, redeploy service
```

### Infrastructure Management

```bash
make terraform              # Deploy cloud servers
make terraform_destroy      # Destroy cloud servers
make tag <tag>              # Run tasks with specific Ansible tag
make update                 # Update services only (skip setup)
make restart                # Restart all services
make stop                   # Stop all services
make uninstall              # Remove all services
make restore                # Restore from backup
  make vagrant                # Spin up local development stack (see docs/development/vagrant.md)
```

### Direct Ansible Commands (Non-Interactive)

Use `docker_helper_notty.sh` instead of `docker_helper.sh` when automating to avoid TTY issues:

```bash
# Deploy + restart a single service
./docker_helper_notty.sh ansible-playbook \
  --extra-vars='{"services":["<service>"]}' \
  --extra-vars="@settings/config.yml" \
  --extra-vars="@settings/additional_services_config.yml" \
  --extra-vars="@settings/vault.yml" \
  -i inventory -t deploy playbook.homelabos.yml

./docker_helper_notty.sh ansible-playbook \
  --extra-vars='{"services":["<service>"]}' \
  --extra-vars="@settings/config.yml" \
  --extra-vars="@settings/additional_services_config.yml" \
  --extra-vars="@settings/vault.yml" \
  -i inventory playbook.restart.yml

# Stop a single service
./docker_helper_notty.sh ansible-playbook \
  --extra-vars='{"services":["<service>"]}' \
  --extra-vars="@settings/config.yml" \
  --extra-vars="@settings/additional_services_config.yml" \
  --extra-vars="@settings/vault.yml" \
  -i inventory playbook.stop.yml

# Run any playbook with a custom tag
./docker_helper_notty.sh ansible-playbook \
  --extra-vars="@settings/config.yml" \
  --extra-vars="@settings/vault.yml" \
  -i inventory -t <tag> playbook.homelabos.yml
```

### Linting and Testing

```bash
make lint                   # Run YAML linting (./lint.sh, yamllint.conf)
make test                   # Sanity/deployment tests on all services
make test_one <service>     # Test single service deployment
make develop                # Go sanity checks in a container
go run main.go              # Direct Go execution
go run main.go test         # Run tests directly
```

### Documentation

```bash
make docs_local             # Serve docs locally (port 8000)
make docs_build             # Build documentation with mkdocs
make web                    # Serve website locally (Hugo)
```

## Coding Style & Naming Conventions

- Match existing style in each file; keep YAML indentation consistent with nearby files.
- Service roles follow `roles/<service>/` with `templates/docker-compose.<service>.yml.j2` and `docs.md`.
- Config keys are under `settings/config.yml` as `<service>.enable: true`.
- Go code should remain `gofmt`-clean.

## Working with Services

### Adding a New Service

See [`docs/development/adding_services.md`](docs/development/adding_services.md) for the full guide. Quick reference:

1. Create new role: `./add_package.sh <servicename>` or manually create `roles/<servicename>/`.
2. Add `service.yml`, `tasks/main.yml`, `templates/docker-compose.<servicename>.yml.j2`, and `docs.md` (see Service Role Anatomy above).
3. Run `make config` to regenerate templates.
4. Enable in `settings/config.yml`: `<servicename>.enable: True`.
5. Deploy: `make update_one <servicename>`.

### Modifying an Existing Service

1. Edit files in `roles/<servicename>/`.
2. For config changes: update `additional_configs.yml` and run `make config`.
3. Test: `make reset_one <servicename>` (full redeploy) or `make update_one <servicename>` (update only).

### Service Configuration Override

Create `settings/overrides/<service>.override.yml` to merge custom docker-compose settings during deployment.

### Common Patterns

**Creating service directories:**
```yaml
- name: Make {{ service_item }} directory
  file:
    path: "{{ volumes_root }}/{{ service_item }}"
    state: directory
```

**Generating bcrypt passwords:**
```yaml
- name: Generate bcrypt password hash
  command: >
    python -c 'from passlib.hash import bcrypt; print(bcrypt.hash("{{default_password}}"))'
  register: passwrd
```

**Service-specific additional config** (`roles/<service>/additional_configs.yml`):
```yaml
<service>_extra_param: "{{ <service>.extra_param | default('default_value') }}"
```

## Testing Guidelines

Tests verify service role structure (service.yml and docs.md exist), docker-compose template exists, service deployability, and systemd unit startup.
- Run `make test` for full coverage or `make test_one <service>` for targeted checks.
- For service changes, ensure `service.yml`, `docs.md`, and docker-compose templates stay in sync.

## Security & Configuration Tips

- Secrets live in `settings/vault.yml` (Ansible vault). Vault password at `~/.homelabos_vault_pass`.
- Avoid committing decrypted secrets or local `settings/` changes unless required.

```bash
make decrypt                # Decrypt vault.yml
make encrypt                # Encrypt vault.yml
make set <key> <value>      # Set a configuration value
make get <key>              # Get a configuration value
./set_setting.sh <args>     # Direct setting script
./get_setting.sh <args>     # Direct getter script
```

## Ansible Configuration

- Inventory: `inventory` file (points to server).
- Config: `ansible.cfg`.
- Extra vars: `--extra-vars="@settings/config.yml" --extra-vars="@settings/additional_services_config.yml" --extra-vars="@settings/vault.yml"`.

## Docker Helper

All Ansible commands run through `docker_helper.sh` (interactive) or `docker_helper_notty.sh` (non-TTY, used by Makefile targets). These scripts mount SSH keys, the current directory as `/data`, and the vault password file, and use the `nickbusey/homelabos:${VERSION}` image.

## Key Files

- `Makefile` — Primary interface for all operations.
- `VERSION` — Current version (used for Docker image tag).
- `group_vars/all` — Generated file containing all service variable definitions.
- `templates/config.go` — Go template for config.yml generation.
- `includes/setup.yml` / `includes/start.yml` — Standard service setup/start tasks.
- `docker_helper.sh` — Docker execution wrapper.

## Traefik Reverse Proxy

See [`docs/setup/traefik.md`](docs/setup/traefik.md) for full details. All HTTP(S) services route through Traefik; labels in docker-compose configure routing per service. Runtime config lives under `{{ volumes_root }}/traefik/`.

## Bastion Host Architecture

See [`docs/setup/bastion.md`](docs/setup/bastion.md) for full details. When `bastion.enable: True`, a WireGuard VPN connects the homelab server to a cloud bastion, forwarding ports through the tunnel to enable hosting without a public IP. Configuration in `roles/homelabos_wireguard/` and `roles/homelabos_port_forwarding/`.

## Tor Hidden Services

See [`docs/setup/tor.md`](docs/setup/tor.md) for full details. When `enable_tor: True`, SSH and HTTP hidden services are created. Addresses stored in `/var/lib/tor/ssh-onion/hostname` and `/var/lib/tor/http-onion/hostname`. Configuration in `roles/tor/`.

## Commit & Pull Request Guidelines

See [`docs/development/contributing.md`](docs/development/contributing.md) for the full contribution guide.

- Main branch: `dev`. Use short, present-tense commit messages; optional scopes like `docs:` are welcome (e.g., `docs: fix typo`, `Add <service>`).
- PRs should include a brief summary, testing notes, and any config or docs updates.
- Settings can be auto-synced via `git_sync.sh`; pre-commit hooks available in `git_sync_pre_commit`.
