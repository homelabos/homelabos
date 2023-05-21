# Bazarr

[Bazarr](https://www.bazarr.media/) is a companion application to Bazarr and Radarr that manages and downloads subtitles based on your requirements. 

## Configuration

## Access

Bazarr available at [https://{% if bazarr.domain %}{{ bazarr.domain }}{% else %}{{ bazarr.subdomain + "." + domain }}{% endif %}/](https://{% if bazarr.domain %}{{ bazarr.domain }}{% else %}{{ bazarr.subdomain + "." + domain }}{% endif %}/) or [http://{% if bazarr.domain %}{{ bazarr.domain }}{% else %}{{ bazarr.subdomain + "." + domain }}{% endif %}/](http://{% if bazarr.domain %}{{ bazarr.domain }}{% else %}{{ bazarr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ bazarr.subdomain + "." + tor_domain }}/](http://{{ bazarr.subdomain + "." + tor_domain }}/)
{% endif %}
