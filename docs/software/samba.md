# Samba

[Samba](https://download.samba.org/pub/samba/stable/) Export your HLOS storage_dirs as CIFS/SMB file shares

## Access

It is available at [https://{% if samba.domain %}{{ samba.domain }}{% else %}{{ samba.subdomain + "." + domain }}{% endif %}/](https://{% if samba.domain %}{{ samba.domain }}{% else %}{{ samba.subdomain + "." + domain }}{% endif %}/) or [http://{% if samba.domain %}{{ samba.domain }}{% else %}{{ samba.subdomain + "." + domain }}{% endif %}/](http://{% if samba.domain %}{{ samba.domain }}{% else %}{{ samba.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ samba.subdomain + "." + tor_domain }}/](http://{{ samba.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
samba:
  https_only: True
  auth: True
```
