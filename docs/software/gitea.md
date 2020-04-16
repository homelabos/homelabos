# Gitea

[Gitea](https://gitea.io/en-US/) is a Git hosting platform.

## Access

It is available at [https://{{services.gitea.subdomain}}.{{ domain }}/](https://{{services.gitea.subdomain}}.{{ domain }}/) or [http://{{services.gitea.subdomain}}.{{ domain }}/](http://{{services.gitea.subdomain}}.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://{{services.gitea.subdomain}}.{{ tor_domain }}/](http://{{services.gitea.subdomain}}.{{ tor_domain }}/)
{% endif %}

### MariaDB
{% if services.gitea.use_mariadb %}
- Defaults true
- False allows for SQLite option without database in separate container
{% endif %}

### SSH Port
{{ services.gitea.gitea_ssh_port }} - defaults to 222, can be adjusted
- Default is 222
- Adjust in settings/config.yml
