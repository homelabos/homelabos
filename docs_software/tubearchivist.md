# Tubearchivist

[Tubearchivist](https://github.com/bbilly1/tubearchivist) Your self hosted YouTube media server

## Deleting channels

Please notice that when you delete a channel Tubearchivist will automatically delete all videos from the channel.

Tubearchivist is not meant to be a personal Youtube subscription backup!

For backups purposes you would better check, for example, [TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection](https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection/)

## Access

Admin credentials can be found in the generated `/var/homelabos/tubearchivist/docker-compose.yml`:
- Admin username is defined in `TA_USERNAME` variable which is `tubearchivist` by default
- Admin password is defined in `TA_PASSWORD` variable. Ansible will generate a random password

Feel free to create a different user with your own credentials if you feel like doing so

----

It is available at [https://{% if tubearchivist.domain %}{{ tubearchivist.domain }}{% else %}{{ tubearchivist.subdomain + "." + domain }}{% endif %}/](https://{% if tubearchivist.domain %}{{ tubearchivist.domain }}{% else %}{{ tubearchivist.subdomain + "." + domain }}{% endif %}/) or [http://{% if tubearchivist.domain %}{{ tubearchivist.domain }}{% else %}{{ tubearchivist.subdomain + "." + domain }}{% endif %}/](http://{% if tubearchivist.domain %}{{ tubearchivist.domain }}{% else %}{{ tubearchivist.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ tubearchivist.subdomain + "." + tor_domain }}/](http://{{ tubearchivist.subdomain + "." + tor_domain }}/)
{% endif %}
