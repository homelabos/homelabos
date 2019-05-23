# Calibre

[Calibre](https://calibre-ebook.com) Ebook management system.

[Calibre Web](https://github.com/janeczku/calibre-web) Web app for accessing ebook library

## Access

It is available at [https://calibre.{{ domain }}/](https://calibre.{{ domain }}/) or [http://calibre.{{ domain }}/](http://calibre.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://calibre.{{ tor_domain }}/](http://calibre.{{ tor_domain }}/)
{% endif %}
