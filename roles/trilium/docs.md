# Trilium

[Trilium](https://github.com/zadam/trilium) Build your personal knowledge base with Trilium Notes

## Access

It is available at [https://{% if trilium.domain %}{{ trilium.domain }}{% else %}{{ trilium.subdomain + "." + domain }}{% endif %}/](https://{% if trilium.domain %}{{ trilium.domain }}{% else %}{{ trilium.subdomain + "." + domain }}{% endif %}/) or [http://{% if trilium.domain %}{{ trilium.domain }}{% else %}{{ trilium.subdomain + "." + domain }}{% endif %}/](http://{% if trilium.domain %}{{ trilium.domain }}{% else %}{{ trilium.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ trilium.subdomain + "." + tor_domain }}/](http://{{ trilium.subdomain + "." + tor_domain }}/)
{% endif %}
