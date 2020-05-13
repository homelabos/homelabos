# MStream

[MStream](https://www.mstream.io) All your music, everywhere you go.

## Access

It is available at [https://{% if mstream.domain %}{{ mstream.domain }}{% else %}{{ mstream.subdomain + "." + domain }}{% endif %}/](https://{% if mstream.domain %}{{ mstream.domain }}{% else %}{{ mstream.subdomain + "." + domain }}{% endif %}/) or [http://{% if mstream.domain %}{{ mstream.domain }}{% else %}{{ mstream.subdomain + "." + domain }}{% endif %}/](http://{% if mstream.domain %}{{ mstream.domain }}{% else %}{{ mstream.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ mstream.subdomain + "." + tor_domain }}/](http://{{ mstream.subdomain + "." + tor_domain }}/)
{% endif %}
