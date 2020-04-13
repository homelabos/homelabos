# Bitwarden

[Bitwarden](https://bitwarden.com/) is an open source password manager. HomelabOS utilizes an Open Source clone of the Bitwarden API server, [bitwarden_rs](https://github.com/dani-garcia/bitwarden_rs). This is primarily due to performance and complexity reasons. `bitwarden_rs` requires just one Docker container, whereas the official `Bitwarden` install requires something like six different containers.

## Security Note

Password managers like Bitwarden should only be used over HTTPS. Ensure you have valid certificates in place before beginning to use this service. You have been warned. :)

## Access

It is available at [https://bitwarden.{{ domain }}/](https://bitwarden.{{ domain }}/) or [http://bitwarden.{{ domain }}/](http://bitwarden.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://bitwarden.{{ tor_domain }}/](http://bitwarden.{{ tor_domain }}/)
{% endif %}
