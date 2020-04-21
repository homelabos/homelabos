# Minio

Minio is an S3 storage utility.

## Configuration

Refer to the [Backup Guide](../setup/backups.md) for configuration details.

## Access

The dashboard is available at [https://minio.{{ domain }}/](https://minio.{{ domain }}/) or [http://minio.{{ domain }}/](http://minio.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://minio.{{ tor_domain }}/](http://minio.{{ tor_domain }}/)
{% endif %}
