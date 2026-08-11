# Authentik

[Authentik](https://goauthentik.io/) is an open-source identity provider for modern SSO. It supports OAuth2/OIDC, SAML, LDAP, and more.

The Docker image comes from [ghcr.io/goauthentik/server](https://github.com/goauthentik/authentik).

## Setup

After enabling and deploying Authentik, complete the initial setup flow:

[https://{% if authentik.domain %}{{ authentik.domain }}{% else %}{{ authentik.subdomain + "." + domain }}{% endif %}/if/flow/initial-setup/](https://{% if authentik.domain %}{{ authentik.domain }}{% else %}{{ authentik.subdomain + "." + domain }}{% endif %}/if/flow/initial-setup/)

Create your admin account during this flow. Authentik stores its data in `{{ volumes_root }}/authentik/data/`.

The worker container mounts the Docker socket so Authentik can deploy and manage outposts automatically.

## Access

It is available at [https://{% if authentik.domain %}{{ authentik.domain }}{% else %}{{ authentik.subdomain + "." + domain }}{% endif %}/](https://{% if authentik.domain %}{{ authentik.domain }}{% else %}{{ authentik.subdomain + "." + domain }}{% endif %}/) or [http://{% if authentik.domain %}{{ authentik.domain }}{% else %}{{ authentik.subdomain + "." + domain }}{% endif %}/](http://{% if authentik.domain %}{{ authentik.domain }}{% else %}{{ authentik.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ authentik.subdomain + "." + tor_domain }}/](http://{{ authentik.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
authentik:
  https_only: True
  auth: True
```

## Traefik integration

Authentik can protect other HomelabOS services via Traefik forward auth. See the [Authentik Traefik docs](https://docs.goauthentik.io/add-secure-apps/providers/proxy/server_traefik/) after creating a proxy provider and outpost in the Authentik admin UI.
