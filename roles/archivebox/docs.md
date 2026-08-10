# ArchiveBox

[ArchiveBox](https://github.com/ArchiveBox/ArchiveBox) is a self-hosted web archiving service that saves web pages, media, and snapshots for long-term preservation.

## Access

It is available at [https://{% if archivebox.domain %}{{ archivebox.domain }}{% else %}{{ archivebox.subdomain + "." + domain }}{% endif %}/](https://{% if archivebox.domain %}{{ archivebox.domain }}{% else %}{{ archivebox.subdomain + "." + domain }}{% endif %}/) or [http://{% if archivebox.domain %}{{ archivebox.domain }}{% else %}{{ archivebox.subdomain + "." + domain }}{% endif %}/](http://{% if archivebox.domain %}{{ archivebox.domain }}{% else %}{{ archivebox.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ archivebox.subdomain + "." + tor_domain }}/](http://{{ archivebox.subdomain + "." + tor_domain }}/)
{% endif %}

## Notes

- ArchiveBox stores its persistent data in `{{ volumes_root }}/archivebox/data`.
- The initial admin user is created from `default_username` and `default_password` on first startup.
- Additional ArchiveBox runtime settings can be adjusted in `settings/config.yml` under the `archivebox:` key.
