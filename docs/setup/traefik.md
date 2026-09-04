{% raw %}
# Traefik

[Traefik v2](https://traefik.io/) is a modern HTTP reverse proxy and load balancer, which is used by HomelabOS to automatically make accessible all the docker containers, both on http and https (with Let's Encrypt certificate).

## Exposing other services

If you want to add other services - either hosted on the same host, or somewhere else on your network - to benefit from the provided convenience of subdomains and auth provided by HomelabOS, you have to create a file on the homelabos host.

The file needs to be in the folder `{{ volumes_root }}/traefik/conf.d/` and could be named `{service_name}.yaml`

Example configuration:
```
http:
  routers:
    {service_name}-http:
      rule: "Host(`{service_name}.{domain}`)"
      entryPoints:
        - "http"
      middlewares:
        - "auth@file"
      service: "{service_name}"
    {service_name}:
      rule: "Host(`{service_name}.{domain}`)"
      entryPoints:
        - "https"
      middlewares:
        - "redirect@file"
      service: "{service_name}"
      tls:
        certResolver: "{certresolver (dns/web)}"
        domains:
           - main: "{domain}"
             sans:
               - "*.{domain}"

  services:
    {service_name}:
      loadBalancer:
        passHostHeader: true
        servers:
          - url: "http://{ip}:{port}"

```
Example tcp service (unifi cloudkey controller with own https)
```
tcp:
  routers:
    {service_name}-tcp:
      rule: "HostSNI(`unifi.{{ domain }}`)"
      entryPoints:
        - "https"
      service: "{service_name}"
      tls:
        passthrough: true

  services:
    {service_name}:
      loadBalancer:
        passHostHeader: true
        servers:
          - address: "{ip}:8443"
```

Add as many files/services as you need.

This will make your service accessible under https://{service_name}.{{ domain }}/. Be aware, that because Traefik runs inside docker, you need to use addresses, which can be reached from there - so `http://localhost:13000/` won't work.

## Middlewares

* authelia@file (Authelia authentification)
* authelia-tor@file (Authelia authentification / tor domain redirect)
* basicAuth@file (basic auth using default username and password)
* customFrameHomelab (default frame Headers)
* customFrameHomelab-tor (default tor domain frame Headers)
* redirect@file (redirect to https)

### customFrameHomelab
* ALLOW-FROM http://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}
* ALLOW-FROM https://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}

### customFrameHomelab-tor
* ALLOW-FROM http://{{ organizr.subdomain + "." + tor_domain }}

## Server-side Matomo tracking

When the `matomo` service is enabled, HomelabOS registers the open source
[MatomoTracking](https://plugins.traefik.io/plugins/677d094a86fc372d4dc11fa3/matomo-tracking)
middleware plugin (from [github.com/DIE-Bonn/MatomoTracking](https://github.com/DIE-Bonn/MatomoTracking))
inside Traefik. It inspects every HTTPS request arriving through the `https`
entrypoint and, for any tracked domain, posts a server-side tracking request to
Matomo on the backend. Because tracking happens server-side it is not
blockable by browser extensions or ad-blockers, unlike Matomo's usual
JavaScript tracking.

Behaviour:

* Every enabled service's domain (`<service>.{{ domain }}` or a service custom
  `domain`) is tracked into a single Matomo site (`matomo.site_id`, default
  `1` — the first website created by the automated install wizard).
* The tracker maps the exact request host to a domain entry, so only the domains
  listed are forwarded. The Matomo service's own domain is deliberately not
  tracked, so admin clicks inside Matomo are not recorded.
* Tracking requests are sent directly to the Matomo container
  (`http://matomo/matomo.php`) over the `homelabos_traefik` Docker network,
  bypassing Traefik itself. This avoids the middleware re-processing its own
  tracking traffic and keeps tracking working even if Matomo is placed behind
  HTTP basic-auth or Authelia.
* Static assets (images, CSS, JS, fonts, video, PDFs, archives) and
  `/favicon.*` are excluded so assets are not recorded as pageviews.

To disable server-side tracking, disable the `matomo` service.

Note: the plugin logs diagnostic output to the Traefik container's stdout on
every request; this is normal and harmless.
{% endraw %}