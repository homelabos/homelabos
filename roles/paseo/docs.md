# Paseo

[Paseo](https://paseo.sh/) is an orchestrator for running coding agents (Claude Code, Codex, Copilot, OpenCode, and Pi) from a self-hosted daemon, with a bundled web UI.

The Docker image comes from [ghcr.io/getpaseo/paseo](https://github.com/getpaseo/paseo).

## Access

It is available at [https://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/](https://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/) or [http://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/](http://{% if paseo.domain %}{{ paseo.domain }}{% else %}{{ paseo.subdomain + "." + domain }}{% endif %}/)

On first load, add a direct daemon connection using your HomelabOS default password (override with `paseo.paseo_password`).

The base image does not install agent CLIs (Claude Code, Codex, etc.). To run agents, extend the image to add them — see the [Paseo Docker docs](https://github.com/getpaseo/paseo/blob/main/docs/docker.md).

{% if enable_tor %}
It is also available via Tor at [http://{{ paseo.subdomain + "." + tor_domain }}/](http://{{ paseo.subdomain + "." + tor_domain }}/)
{% endif %}
