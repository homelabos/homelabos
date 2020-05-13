# BulletNotes

[BulletNotes](https://gitlab.com/NickBusey/BulletNotes/) is an open source note taking app.

## Access

It is available at [https://{% if bulletnotes.domain %}{{ bulletnotes.domain }}{% else %}{{ bulletnotes.subdomain + "." + domain }}{% endif %}/](https://{% if bulletnotes.domain %}{{ bulletnotes.domain }}{% else %}{{ bulletnotes.subdomain + "." + domain }}{% endif %}/) or [http://{% if bulletnotes.domain %}{{ bulletnotes.domain }}{% else %}{{ bulletnotes.subdomain + "." + domain }}{% endif %}/](http://{% if bulletnotes.domain %}{{ bulletnotes.domain }}{% else %}{{ bulletnotes.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ bulletnotes.subdomain + "." + tor_domain }}/](http://{{ bulletnotes.subdomain + "." + tor_domain }}/)
{% endif %}
