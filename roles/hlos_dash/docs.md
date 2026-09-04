# HomelabOS Dash

HomelabOS Dash is a control-plane dashboard for a HomelabOS install. It lets you
browse and edit the HomelabOS settings (`settings/config.yml`), compare them
against the deployed lock file, and trigger redeploys from a web UI.

A Go HTTP API (`server/`) reads and patches the HomelabOS settings, runs the
HomelabOS deploy, and serves the dashboard's data. A React SPA (`web/`) is
served by nginx and talks to the API over `/v1/`.

## Setup

After enabling and deploying HomelabOS Dash, open the dashboard at:

```
https://{% if hlos_dash.domain %}{{ hlos_dash.domain }}{% else %}{{ hlos_dash.subdomain + "." + domain }}{% endif %}/
```

The web service is exposed through Traefik; the API container is not publicly
exposed.

## Configuration

The dashboard manages the HomelabOS install that it runs in. The `hlos_dash.install_dir`
config key sets the host path of that HomelabOS checkout (bind-mounted into the
API container at `/data`):

```
hlos_dash:
  install_dir: /var/homelabos/install
```

It defaults to `{{ volumes_root }}/install`.

## Access

It is available at [https://{% if hlos_dash.domain %}{{ hlos_dash.domain }}{% else %}{{ hlos_dash.subdomain + "." + domain }}{% endif %}/](https://{% if hlos_dash.domain %}{{ hlos_dash.domain }}{% else %}{{ hlos_dash.subdomain + "." + domain }}{% endif %}/) or [http://{% if hlos_dash.domain %}{{ hlos_dash.domain }}{% else %}{{ hlos_dash.subdomain + "." + domain }}{% endif %}/](http://{% if hlos_dash.domain %}{{ hlos_dash.domain }}{% else %}{{ hlos_dash.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ hlos_dash.subdomain + "." + tor_domain }}/](http://{{ hlos_dash.subdomain + "." + tor_domain }}/)
{% endif %}

## Security

HomelabOS Dash is a privileged control-plane service: the API container mounts
the host HomelabOS directory read-write and the Docker socket, so it can edit
settings and trigger redeploys. It is enabled by default on fresh installs and
is intended for the HomelabOS administrator.

The API is gated by a bearer token. The token is generated on first deploy and
stored at `settings/passwords/hlos_dash_api_token`. Enter it in the dashboard's
"Enter API token" screen to connect.
