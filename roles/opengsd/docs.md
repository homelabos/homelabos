# Open GSD

[Open GSD](https://opengsd.net/) (GSD Pi) is an open source autonomous coding agent harness. This service runs the GSD Pi **web interface** (`gsd --web`) so you can drive projects from your browser instead of a local terminal: a project dashboard with milestones/slices/tasks, live session monitoring over server-sent events, a built-in xterm.js terminal, project/knowledge browsing, and a preferences editor.

The Docker image comes from [ghcr.io/open-gsd/gsd-pi](https://github.com/open-gsd/gsd-pi) (image has the `gsd` CLI as its entrypoint; the web build ships in the package).

## Setup

After enabling and deploying Open GSD, you are prompted for HTTP basic auth using the HomelabOS credentials (username `{{ default_username }}`, password `{{ default_password }}`).

The web server runs with GSD's own token auth disabled (`--no-auth`) and is exposed on `0.0.0.0` via `GSD_WEB_ALLOW_UNAUTHENTICATED_LAN=1` — this is safe only because Traefik basic auth guards the route. Do **not** set `opengsd.auth: False` while `--no-auth` is in effect: the interface exposes terminal and file APIs to the network.

## Authentication

- Traefik basic auth (HomelabOS default credentials) is the access control for this interface.
- Open GSD logs `WARNING: Web token auth is disabled` on startup by design; it is protected by the reverse proxy.
- If you prefer GSD's own per-launch bearer token instead, remove the `--no-auth` flag from the compose template and append `#token=<token>` (shown in the container logs on the `Ready →` line) to the URL.

## Persistent State and Workspace

- `{{ volumes_root }}/opengsd/state` is mounted at `/root/.gsd` — GSD's configuration, sessions, and project memory persist across restarts.
- The host `{{ volumes_root }}` is mounted at `/workspace`, the default project root (`GSD_WEB_PROJECT_CWD=/workspace`). Create or open project directories under `{{ volumes_root }}` from the web UI.

## Configuring Providers

The web interface's preferences/onboarding flow can configure LLM providers interactively. You can also pre-seed provider API keys in `settings/config.yml`:

```
opengsd:
  enable: True
  anthropic_api_key: sk-ant-...
  openai_api_key: sk-...
  openrouter_api_key: sk-or-...
  gemini_api_key: ...
```

These are passed to the container as `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `OPENROUTER_API_KEY`, and `GEMINI_API_KEY` environment variables.

## Access

It is available at [https://{% if opengsd.domain %}{{ opengsd.domain }}{% else %}{{ opengsd.subdomain + "." + domain }}{% endif %}/](https://{% if opengsd.domain %}{{ opengsd.domain }}{% else %}{{ opengsd.subdomain + "." + domain }}{% endif %}/) or [http://{% if opengsd.domain %}{{ opengsd.domain }}{% else %}{{ opengsd.subdomain + "." + domain }}{% endif %}/](http://{% if opengsd.domain %}{{ opengsd.domain }}{% else %}{{ opengsd.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ opengsd.subdomain + "." + tor_domain }}/](http://{{ opengsd.subdomain + "." + tor_domain }}/)
{% endif %}
