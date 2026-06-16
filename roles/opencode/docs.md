# OpenCode

[OpenCode](https://opencode.ai/) is an open source AI coding agent. This service runs the OpenCode web UI so you can use it from your browser without a local terminal install.

The Docker image comes from [ghcr.io/anomalyco/opencode](https://github.com/anomalyco/opencode).

## Setup

After enabling and deploying OpenCode, sign in with the default HomelabOS credentials:

- Username: `opencode` (override with `opencode.server_username`)
- Password: your HomelabOS default password (override with `opencode.server_password`)

Configure LLM providers by placing an `opencode.json` file in `{{ volumes_root }}/opencode/config/`. See the [OpenCode docs](https://opencode.ai/docs/) for provider setup.

Project files are available at `{{ volumes_root }}/` (mounted as `/workspace` in the container).

## Access

It is available at [https://{% if opencode.domain %}{{ opencode.domain }}{% else %}{{ opencode.subdomain + "." + domain }}{% endif %}/](https://{% if opencode.domain %}{{ opencode.domain }}{% else %}{{ opencode.subdomain + "." + domain }}{% endif %}/) or [http://{% if opencode.domain %}{{ opencode.domain }}{% else %}{{ opencode.subdomain + "." + domain }}{% endif %}/](http://{% if opencode.domain %}{{ opencode.domain }}{% else %}{{ opencode.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ opencode.subdomain + "." + tor_domain }}/](http://{{ opencode.subdomain + "." + tor_domain }}/)
{% endif %}
