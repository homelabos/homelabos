# Traefik

[Traefik v2](https://traefik.io/) is a modern HTTP reverse proxy and load balancer, which is used by HomelabOS to automatically make accessible all the docker containers, both on http and https (with Let's Encrypt certificate).
If you want to add other services - either hosted on the same host, or somewhere else - to benefit from the provided convenience, you have to create a file on the homelabos host.

The file needs to be in the folder /var/homelabos/traefik/conf.d/ and could be named {service_name}.yaml

Example configuration:
```
http:
  routers:
    {service_name}-http:
      rule: "Host(`{service_name}.{domain}`)"
      entryPoints:
        - "http"
      middlewares: #https://docs.{{ domain }}/setup/traefik/
        - "auth@file"
      service: "{service_name}"
    {service_name}:
      rule: "Host(`{service_name}.{domain}`)"
      entryPoints:
        - "https"
      middlewares: #https://docs.{{ domain }}/setup/traefik/
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
* basicAuth@file (basic auth using default username and password)
* customFrameHomelab (default frame Headers)
* redirect@file (redirect to https)

### customFrameHomelab
* ALLOW-FROM http://homelab.{{ domain }}
* ALLOW-FROM https://homelab.{{ domain }}
