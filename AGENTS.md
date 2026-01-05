# Repository Guidelines

## Project Structure & Module Organization
HomelabOS is an Ansible-driven deployment system with a Go CLI for generating config and docs.
- Go CLI: `main.go`, `cmd/`, `services/` (service metadata aggregation and generators).
- Ansible playbooks: `playbook.*.yml` (deploy, config, lifecycle tasks).
- Roles: `roles/` (one directory per service with `service.yml`, `tasks/main.yml`, `templates/`).
- Shared templates and tasks: `templates/`, `includes/`.
- Configuration and secrets: `settings/` (runtime), `config.yml.blank` (seed), `group_vars/all` (generated).
- Docs and site: `docs/`, `mkdocs.yml`, `website/`.

## Build, Test, and Development Commands
- `make` / `make deploy`: full build + deploy via Dockerized Ansible.
- `make config`: regenerate configs and prompt for settings.
- `make build` / `make rebuild`: build the deployment Docker image.
- `make update_one <service>` / `make restart_one <service>`: operate on a single service.
- `make lint`: run YAML linting (`./lint.sh`, `yamllint.conf`).
- `make test` / `make test_one <service>`: run service sanity/deploy tests (`go run main.go test`).
- `make develop`: Go sanity checks in a container.

## Coding Style & Naming Conventions
- Match existing style in each file; keep YAML indentation consistent with nearby files.
- Service roles follow `roles/<service>/` with `templates/docker-compose.<service>.yml.j2` and `docs.md`.
- Config keys are under `settings/config.yml` as `<service>.enable: true`.
- Go code should remain `gofmt`-clean.

## Testing Guidelines
Tests validate service role structure and basic deployability.
- Run `make test` for full coverage or `make test_one <service>` for targeted checks.
- For service changes, ensure `service.yml`, `docs.md`, and docker-compose templates stay in sync.

## Commit & Pull Request Guidelines
Recent history uses short, present-tense messages; optional scopes like `docs:` appear.
- Keep commits focused and descriptive (e.g., `docs: fix typo`, `Add <service>`).
- PRs should include a brief summary, testing notes, and any config or docs updates.

## Security & Configuration Tips
- Secrets live in `settings/vault.yml` (Ansible vault). Use `make encrypt`/`make decrypt`.
- Avoid committing decrypted secrets or local `settings/` changes unless required.
