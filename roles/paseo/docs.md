# Paseo

[Paseo](https://paseo.sh/) is an orchestrator for running coding agents (Claude Code, Codex, Copilot, OpenCode, and Pi) from a self-hosted daemon, with a bundled web UI.

The Docker image comes from [ghcr.io/getpaseo/paseo](https://github.com/getpaseo/paseo).

## Access

It is available at [https://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/](https://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/) or [http://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/](http://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/)

On first load, add a direct daemon connection using your HomelabOS default password (override with `paseo.paseo_password`).

The base image does not install agent CLIs (Claude Code, Codex, etc.). To run agents, extend the image to add them — see the [Paseo Docker docs](https://github.com/getpaseo/paseo/blob/main/docs/docker.md).

Paseo runs as container user `paseo` (uid 1000) with `HOME=/home/paseo`. OMP (Pi) persists its SQLite data (`~/.omp/agent/{agent,history,stats,models}.db`) under `/home/paseo`, which is bind-mounted to `{{ volumes_root }}/paseo/paseo-home`. The service creates the home and OMP data directories owned by uid 1000 with mode 0700 so OMP can write its databases without relying on world-writable permissions or host-side folder ownership hacks.

Do not add a separate `/root/.omp:/home/paseo/.omp` bind via `paseo.additional_volumes` — it shadows the OMP data directory with a root-owned volume and breaks SQLite writes (SQLITE_CANTOPEN).

Never invoke `omp` as root inside the container or on the host against this home: the daemon and its OMP RPC processes run as uid 1000, and a root-owned 0600 `~/.omp/agent/config.yml` is unreadable by them, killing the provider snapshot manager with `EACCES: permission denied` / "OMP RPC process exited with code 1". On every deploy the playbook recursively normalizes ownership of `{{ volumes_root }}/paseo/paseo-home` back to uid 1000, so a mis-owned volume self-heals on the next run instead of requiring a manual delete. To fix a running instance immediately, `chown -R 1000:1000 {{ volumes_root }}/paseo/paseo-home` and restart the Paseo container.

OMP web search uses Brave: set `paseo.brave_api_key` (deployed as `BRAVE_API_KEY` in the container environment and `~/.omp/agent/.env`); OMP then prefers Brave for the `web_search` tool.

{% if enable_tor %}
It is also available via Tor at [http://{{ paseo.subdomain + "." + tor_domain }}/](http://{{ paseo.subdomain + "." + tor_domain }}/)
{% endif %}
