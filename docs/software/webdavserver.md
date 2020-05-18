# WebDAV Server

[WebDAV Server](https://hub.docker.com/r/bytemark/webdav/) A simple WebDAV service.
If you enable WebDAV over SSL you will have a secure file transfer service setup, which is useful for e.g. syncing your notes from Joplin.
If you don't need all the extra from NextCloud/OwnCloud, this service could be what you need.

Files are stored in {{ storage_dir }}/webdav/data .

It is strongly recommended to only allow access over https.

## Access

It is available at [https://{% if webdavserver.domain %}{{ webdavserver.domain }}{% else %}{{ webdavserver.subdomain + "." + domain }}{% endif %}/](https://{% if webdavserver.domain %}{{ webdavserver.domain }}{% else %}{{ webdavserver.subdomain + "." + domain }}{% endif %}/) or [http://{% if webdavserver.domain %}{{ webdavserver.domain }}{% else %}{{ webdavserver.subdomain + "." + domain }}{% endif %}/](http://{% if webdavserver.domain %}{{ webdavserver.domain }}{% else %}{{ webdavserver.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://webdav.{{ tor_domain }}/](http://webdav.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

webdavserver:
  https_only: True
  auth: True
