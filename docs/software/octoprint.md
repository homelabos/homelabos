# OctoPrint

[OctoPrint](https://octoprint.org/) The snappy web interface for your 3D printer.

## Setup
To find the serial port and connect to your printer run
```
ls /dev/serial/by-id/*
```
then, set the value that corresponds to the 3D printer by running
```
make set octoprint.serial [SERIAL ADDRESS HERE]
```

## Access

It is available at [https://{% if octoprint.domain %}{{ octoprint.domain }}{% else %}{{ octoprint.subdomain + "." + domain }}{% endif %}/](https://{% if octoprint.domain %}{{ octoprint.domain }}{% else %}{{ octoprint.subdomain + "." + domain }}{% endif %}/) or [http://{% if octoprint.domain %}{{ octoprint.domain }}{% else %}{{ octoprint.subdomain + "." + domain }}{% endif %}/](http://{% if octoprint.domain %}{{ octoprint.domain }}{% else %}{{ octoprint.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ octoprint.subdomain + "." + tor_domain }}/](http://{{ octoprint.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
octoprint:
  https_only: True
  auth: True
  serial: False
```
