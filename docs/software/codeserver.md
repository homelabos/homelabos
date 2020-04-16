# Codeserver

[Codeserver](https://github.com/cdr/code-server) Run VS Code on a remote server.

## Access

It is available at [https://codeserver.{{ domain }}/](https://codeserver.{{ domain }}/) or [http://codeserver.{{ domain }}/](http://codeserver.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://codeserver.{{ tor_domain }}/](http://codeserver.{{ tor_domain }}/)
{% endif %}
