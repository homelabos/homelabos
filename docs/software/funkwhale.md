# Funkwhale

[Funkwhale](https://Funkwhale.audio/en_US/) A social platform to enjoy and share music

## Access

It is available at [https://{% if funkwhale.domain %}{{ funkwhale.domain }}{% else %}{{ funkwhale.subdomain + "." + domain }}{% endif %}/](https://{% if funkwhale.domain %}{{ funkwhale.domain }}{% else %}{{ funkwhale.subdomain + "." + domain }}{% endif %}/) or [http://{% if funkwhale.domain %}{{ funkwhale.domain }}{% else %}{{ funkwhale.subdomain + "." + domain }}{% endif %}/](http://{% if funkwhale.domain %}{{ funkwhale.domain }}{% else %}{{ funkwhale.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ funkwhale.subdomain + "." + tor_domain }}/](http://{{ funkwhale.subdomain + "." + tor_domain }}/)
{% endif %}

Once your funkwhale instance is running, you'll need to SSH into your server and run:

```
docker exec -it funkwhale_app_1 python /app/api/manage.py createsuperuser
```

Now login to your funkwhale instance, and create a Library at [http://{% if funkwhale.domain %}{{ funkwhale.domain }}{% else %}{{ funkwhale.subdomain + "." + domain }}{% endif %}/content/libraries](http://{% if funkwhale.domain %}{{ funkwhale.domain }}{% else %}{{ funkwhale.subdomain + "." + domain }}{% endif %}/content/libraries)

Get the library ID by grabbing the last bit of the URL for the new library. It should look like `e42019fe-14fe-475c-a5e6-a84dea4184cd`

Now import your music with:

```
export LIBRARY_ID="<YOUR_LIBRARY_ID>"
docker exec -it funkwhale_app_1 python /app/api/manage.py import_files $LIBRARY_ID "/data/music/" --recursive --noinput
```

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
funkwhale:
  https_only: True
  auth: True
```