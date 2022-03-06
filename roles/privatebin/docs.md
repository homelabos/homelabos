# PrivateBin

[PrivateBin](https://privatebin.info) PrivateBin is a minimalist, open source online pastebin where the server has zero knowledge of pasted data.

## Access

It is available at [https://{% if privatebin.domain %}{{ privatebin.domain }}{% else %}{{ privatebin.subdomain + "." + domain }}{% endif %}/](https://{% if privatebin.domain %}{{ privatebin.domain }}{% else %}{{ privatebin.subdomain + "." + domain }}{% endif %}/) or [http://{% if privatebin.domain %}{{ privatebin.domain }}{% else %}{{ privatebin.subdomain + "." + domain }}{% endif %}/](http://{% if privatebin.domain %}{{ privatebin.domain }}{% else %}{{ privatebin.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ privatebin.subdomain + "." + tor_domain }}/](http://{{ privatebin.subdomain + "." + tor_domain }}/)
{% endif %}

## Known Problems
For some reason, the volume mounts to PrivateBin sometimes don't work immediately after it's installed, causing it to fail after complaining that it can't access /srv/data/.htaccess.  A simple restart of the systemd service (`sudo systemctl restart privatebin`) seems to fix this.
