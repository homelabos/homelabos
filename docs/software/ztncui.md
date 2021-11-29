# ZeroTier network controller user interface

[ztncui](https://github.com/key-networks/ztncui) ZeroTier network controller user interface


## Access

Admin credentials can be found in the generated `/var/homelabos/ztncui/docker-compose.yml`:
- Admin username is `admin`
- Admin password is defined in `ZTNCUI_PASSWD` variable. Ansible will generate a random password


----

It is available at [https://{% if ztncui.domain %}{{ ztncui.domain }}{% else %}{{ ztncui.subdomain + "." + domain }}{% endif %}/](https://{% if ztncui.domain %}{{ ztncui.domain }}{% else %}{{ ztncui.subdomain + "." + domain }}{% endif %}/) or [http://{% if ztncui.domain %}{{ ztncui.domain }}{% else %}{{ ztncui.subdomain + "." + domain }}{% endif %}/](http://{% if ztncui.domain %}{{ ztncui.domain }}{% else %}{{ ztncui.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ ztncui.subdomain + "." + tor_domain }}/](http://{{ ztncui.subdomain + "." + tor_domain }}/)
{% endif %}
