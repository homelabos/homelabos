# Gitea

[Gitea](https://gitea.io/en-US/) is a Git hosting platform.

## Access

It is available at [https://git.{{ domain }}/](https://git.{{ domain }}/) or [http://git.{{ domain }}/](http://git.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://git.{{ tor_domain }}/](http://git.{{ tor_domain }}/)
{% endif %}

### MariaDB
{% if use_mariadb %}
- Defaults true
- False allows for SQLite option without database in separate container
{% endif %}

### SSH Port
{{ gitea_ssh_port }} - defaults to 222, can be adjusted
- Default is 222
- Adjust in settings/config.yml
