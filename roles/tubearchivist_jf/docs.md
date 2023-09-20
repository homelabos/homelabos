# Tubearchivist-jf

[Tubearchivist-jf](https://github.com/tubearchivist/tubearchivist-jf) Import your Tube Archivist media folder into Jellyfin

## Integration

Following the guide on the [github page](https://github.com/tubearchivist/tubearchivist-jf) will generally work. There are a few things to note:

* Tubearchivists-jf expects Jellyfin to mount the Tubearchivist media folder as readonly to /youtube.
* Set `tubearchivist_token` and `jellyfin_token` are set in `config.yml`
* Your integration url in Tubearchivist should be set to `json://{% if tubearchivist_jf.domain %}{{ tubearchivist_jf.domain }}{% else %}{{ tubearchivist_jf.subdomain + "." + domain }}{% endif %}`


----

It is available at [https://{% if tubearchivist_jf.domain %}{{ tubearchivist_jf.domain }}{% else %}{{ tubearchivist_jf.subdomain + "." + domain }}{% endif %}/](https://{% if tubearchivist_jf.domain %}{{ tubearchivist_jf.domain }}{% else %}{{ tubearchivist_jf.subdomain + "." + domain }}{% endif %}/) or [http://{% if tubearchivist_jf.domain %}{{ tubearchivist_jf.domain }}{% else %}{{ tubearchivist_jf.subdomain + "." + domain }}{% endif %}/](http://{% if tubearchivist_jf.domain %}{{ tubearchivist_jf.domain }}{% else %}{{ tubearchivist_jf.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ tubearchivist_jf.subdomain + "." + tor_domain }}/](http://{{ tubearchivist_jf.subdomain + "." + tor_domain }}/)
{% endif %}
