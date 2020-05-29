# Watchtower

[Watchtower](https://containrrr.github.io/watchtower/) A process for automating Docker container base image updates

## Access

It is available at [https://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/](https://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/) or [http://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/](http://{% if watchtower.domain %}{{ watchtower.domain }}{% else %}{{ watchtower.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ watchtower.subdomain + "." + tor_domain }}/](http://{{ watchtower.subdomain + "." + tor_domain }}/)
{% endif %}

## Default

By default, watchtower will watch all containers. However, sometimes only some containers should be updated.

If you need to exclude some containers, set the `com.centurylinklabs.watchtower.enable` label to `false`.

Example:
go to `{{ volumesroot }}/watchtower/` and run `cp docker-compose.yml docker-compose.override.yml` (This creates the override file for you.).
Then edit the file and delete everything that is already in the docker-compose.yml file that you don't want to customize.

from this
```
---
version: '3'

services:
  watchtower:
    image: containrrr/watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      #- "{{ volumes_root }}/watchtower/config.json:/config.json:rw" # Only needed for Private registries
    command: --schedule "0 2 * * *" --cleanup --stop-timeout 30s
    environment:
      - TZ=Europe/Berlin
```

to this
```
---
version: '3'

services:
  watchtower:
```

next you want to add a label

```
---
version: '3'

services:
  watchtower:
    labels:
      - com.centurylinklabs.watchtower.enable=false
```

Run `systemctl restart watchtower`

Now the automatic update for the watchtower image is disabled.
