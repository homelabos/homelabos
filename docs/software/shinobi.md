# Shinobi

[Shinobi](https://gitlab.com/Shinobi-Systems/Shinobi) The Next Generation in Open-Source Video Management Software with support for over 6000 IP and USB Cameras

Login at [https://{% if shinobi.domain %}{{ shinobi.domain }}{% else %}{{ shinobi.subdomain + "." + domain }}{% endif %}/super](https://{% if shinobi.domain %}{{ shinobi.domain }}{% else %}{{ shinobi.subdomain + "." + domain }}{% endif %}/super) with the username and password you configured.

The login credentials are the default username and password you created for services during the initial config.

Follow the [Shinobi documentiton](https://shinobi.video/docs/start#content-account-management) for the rest of the setup and configuration.

## Access

It is available at [https://{% if shinobi.domain %}{{ shinobi.domain }}{% else %}{{ shinobi.subdomain + "." + domain }}{% endif %}/](https://{% if shinobi.domain %}{{ shinobi.domain }}{% else %}{{ shinobi.subdomain + "." + domain }}{% endif %}/) or [http://{% if shinobi.domain %}{{ shinobi.domain }}{% else %}{{ shinobi.subdomain + "." + domain }}{% endif %}/](http://{% if shinobi.domain %}{{ shinobi.domain }}{% else %}{{ airsonic.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ shinobi + "." + tor_domain }}/](http://{{ shinobi + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
shinobi:
  https_only: True
  auth: True
```
