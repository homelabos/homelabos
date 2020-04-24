# Funkwhale

[Funkwhale](https://Funkwhale.audio/en_US/) A social platform to enjoy and share music

## Access

It is available at [https://funkwhale.{{ domain }}/](https://funkwhale.{{ domain }}/) or [http://funkwhale.{{ domain }}/](http://funkwhale.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://funkwhale.{{ tor_domain }}/](http://funkwhale.{{ tor_domain }}/)
{% endif %}

Once your funkwhale instance is running, you'll need to connect to the docker instance and run the following command.

```
python /app/api/manage.py createsuperuser
```

Additionally, you'll want to read [this document on importing your music](https://docs.funkwhale.audio/admin/importing-music.html).

> Note, HomelabOS has already mounted your music folder from the nas in ```/srv/funkwhale/data/music``` 

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

funkwhale:
  https_only: True
  auth: True