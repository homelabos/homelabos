# Docker Compose Overrides

## What is it?

Homelabos allows you to maintain a set of per-service override files. This makes it easy to customize the dockerfiles for each service without fear of an update overwriting your changes.

You can change anything in the compose files with this method; the image being used, a mounted volume.
As well as add anything extra; a database, additional ports or mount points.

[See here](https://docs.docker.com/compose/extends/) for an overview of Docker Compose override files.

## How does it work?

Homelabos will create a directory for you at `settings/overrides`, here you can create a file named like `servicename.override.yml`. If you do not have one yet you can either run `make config` or create the directory yourself, until the below issue is resolved it is best to create the directory if it doesn't exist.

> NOTE: there is a [known issue](https://gitlab.com/NickBusey/HomelabOS/-/issues/638) where the directory might get created with root permissions, until it is fixed you can change the permissions with `sudo chown USERNAME:GROUPNAME settings/overrides`. You will only have to do this once.

This works by first removing all `docker-compose.override.yml` files _from enabled services_ **on the host**, then copying any `servicename.override.yml` files from `settings/overrides` to the host as `{{ volumes_root }}/servicename/docker-compose.override.yml` _for all enabled_ services before restarting the services on the host.

So in short: create, update or remove `servicename.override.yml` files under `settings/overides` and `make` commands will keep them synced to your server.

> NOTE: Currently the override files do not support template values like `{{ storage_dir }}`, this is a [planned enhancment](https://gitlab.com/NickBusey/HomelabOS/-/issues/641).

### Example

Let's look at a basic example.

Say we want to change the port exposed outside the container for Jellyfin.

The original template for the docker-compose, `roles/jellyfin/templates/docker-compose.jellyfin.yml.j2`, file looks like this:
```yaml
---
version: '3'

networks:
  traefik_network:
    external:
      name: homelabos_traefik

services:
  # Media Server
  jellyfin:
    image: jellyfin/jellyfin:{{ jellyfin.version }}
    restart: unless-stopped
    networks:
      - traefik_network
    ports:
      - 8096:8096
    volumes:
      - "{{ volumes_root }}/jellyfin/config:/config"
      - "{{ storage_dir }}:/media"
      - "{{ storage_dir }}/temp:/cache"
    labels:
      - "traefik.http.services.jellyfin.loadbalancer.server.scheme=http"
      - "traefik.http.services.jellyfin.loadbalancer.server.port=8096"
{% include './labels.j2' %}
```

Our override file, `settings/overrides/jellyfin.override.yml`, would look like this:
```yaml
---
version: '3'

services:
  jellyfin:
    ports:
      - 9999:8096
```

Notice how we only need to rewrite to the indentation level where our change will be, that is: under `services` > `jellyfin` > `ports`. Docker will lay these changes overtop of the main compose file.

And if we wanted to also change the media mount point?
```yaml
---
version: '3'

services:
  jellyfin:
    ports:
      - 9999:8096
    volumes:
      "/mnt/NAS/media/video:/media"
```
