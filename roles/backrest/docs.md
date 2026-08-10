# Backrest

[Backrest](https://github.com/garethgeorge/backrest) is a web-accessible backup solution built on top of [restic](https://restic.net/). It provides a WebUI for creating repositories, browsing snapshots, restoring files, and scheduling backups.

## Access

It is available at [https://{% if backrest.domain %}{{ backrest.domain }}{% else %}{{ backrest.subdomain + "." + domain }}{% endif %}/](https://{% if backrest.domain %}{{ backrest.domain }}{% else %}{{ backrest.subdomain + "." + domain }}{% endif %}/) or [http://{% if backrest.domain %}{{ backrest.domain }}{% else %}{{ backrest.subdomain + "." + domain }}{% endif %}/](http://{% if backrest.domain %}{{ backrest.domain }}{% else %}{{ backrest.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ backrest.subdomain + "." + tor_domain }}/](http://{{ backrest.subdomain + "." + tor_domain }}/)
{% endif %}

## Notes

- On first startup, Backrest prompts you to create an admin username and password in the WebUI.
- HomelabOS data is mounted read-only at `/userdata` inside the container for use as a backup source.
- Media storage is mounted read-only at `/storage` inside the container.
- Local restic repositories can be stored in `{{ volumes_root }}/backrest/repos`.
- Rclone configuration can be placed in `{{ volumes_root }}/backrest/rclone`.
