# Mylar

[mylar](https://github.com/evilhero/mylar) An automated Comic Book downloader (cbr/cbz) for use with SABnzbd, NZBGet and torrents

## Access

It is available at [https://{% if mylar.domain %}{{ mylar.domain }}{% else %}{{ mylar.subdomain + "." + domain }}{% endif %}/](https://{% if mylar.domain %}{{ mylar.domain }}{% else %}{{ mylar.subdomain + "." + domain }}{% endif %}/) or [http://{% if mylar.domain %}{{ mylar.domain }}{% else %}{{ mylar.subdomain + "." + domain }}{% endif %}/](http://{% if mylar.domain %}{{ mylar.domain }}{% else %}{{ mylar.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ mylar.subdomain + "." + tor_domain }}/](http://{{ mylar.subdomain + "." + tor_domain }}/)
{% endif %}
