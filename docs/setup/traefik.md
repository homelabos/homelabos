# Traefik

[Traefik](https://traefik.io/) is a modern HTTP reverse proxy and load balancer, which is used by HomelabOS to automatically make accessible all the docker containers, both on http and https (with Let's Encrypt certificate).
If you want to add other services - either hosted on the same host, or somewhere else - to benefit from the provided convenience, you can do it in the `settings/config.yml`:
```
traefik:
  extra_mapping:
    myservice: http://192.168.1.121:13000
```
This will make your service accessible under https://myservice.(your-domain)/. Be aware, that because Traefik runs inside docker, you need to use addresses, which can be reached from there - so `http://localhost:13000/` won't work.

