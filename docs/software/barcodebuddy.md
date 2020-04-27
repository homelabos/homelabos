# BarcodeBuddy

[BarcodeBuddy](https://github.com/Forceu/barcodebuddy) Barcode system for Grocy

## Access

It is available at [https://barcodebuddy.{{ domain }}/](https://barcodebuddy.{{ domain }}/) or [http://barcodebuddy.{{ domain }}/](http://barcodebuddy.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://barcodebuddy.{{ tor_domain }}/](http://barcodebuddy.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only, auth, and image\_tag

To enable https_only or auth set the service config to True
`settings/config.yml`

If you want to specifiy an image tag, set `image_tag` to specified tag.
Available tag at [https://hub.docker.com/r/f0rc3/barcodebuddy-docker/tags](https://hub.docker.com/r/f0rc3/barcodebuddy-docker/tags)

```
barcodebuddy:
  https_only: True
  auth: True
  image_tag: latest
```