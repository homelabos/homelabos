# PrivateBin

[PrivateBin](privatebin) PrivateBin is a minimalist, open source online pastebin where the server has zero knowledge of pasted data.

## Access

It is available at [https://privatebin.{{ domain }}/](https://privatebin.{{ domain }}/) or [http://privatebin.{{ domain }}/](http://privatebin.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://privatebin.{{ tor_domain }}/](http://privatebin.{{ tor_domain }}/)
{% endif %}
