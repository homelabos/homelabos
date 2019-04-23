# Ghost

[Ghost](http://ghost.org/) is a fully open source, adaptable platform for building and running a modern online publication.

## Configuration

It is important to secure Ghost! Access the Ghost admin with [https://ghost.{{ domain }}/ghost/](https://ghost.{{ domain }}/ghost/), and create an account.

## Access

The dashboard is available at [https://ghost.{{ domain }}/](https://ghost.{{ domain }}/) or [http://ghost.{{ domain }}/](http://ghost.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://ghost.{{ tor_domain }}/](http://ghost.{{ tor_domain }}/)
{% endif %}
