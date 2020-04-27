# PackageTitleCase

[PackageTitleCase](PackageURL) PackageOneLiner

## Access

It is available at [https://PackageFileName.{{ domain }}/](https://PackageFileName.{{ domain }}/) or [http://PackageFileName.{{ domain }}/](http://PackageFileName.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://PackageFileName.{{ tor_domain }}/](http://PackageFileName.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

PackageFileName:
  https_only: True
  auth: True