# WebVirtMgr

[WebVirtMgr](https://github.com/retspen/webvirtmgr) is a complete Kernel Virtual Machine (KVM) hypervisor manager.

## Access

It is available at [https://{% if webvirtmgr.domain %}{{ webvirtmgr.domain }}{% else %}{{ webvirtmgr.subdomain + "." + domain }}{% endif %}/](https://{% if webvirtmgr.domain %}{{ webvirtmgr.domain }}{% else %}{{ webvirtmgr.subdomain + "." + domain }}{% endif %}/) or [http://{% if webvirtmgr.domain %}{{ webvirtmgr.domain }}{% else %}{{ webvirtmgr.subdomain + "." + domain }}{% endif %}/](http://{% if webvirtmgr.domain %}{{ webvirtmgr.domain }}{% else %}{{ webvirtmgr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ webvirtmgr.subdomain + "." + tor_domain }}/](http://{{ webvirtmgr.subdomain + "." + tor_domain }}/)
{% endif %}
