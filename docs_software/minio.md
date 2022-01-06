# Minio

Minio is an S3 storage utility.

## Configuration

To expose the Minio console, add the following to your Minio [overrides](../setup/dockeroverrides.md).

```
...
ports:
  - 9110:9000
  - 9200:9001
...
```

You can now connect to port 9001 on your server to access the Minio console.

Refer to the [Backup Guide](../setup/backups.md) for configuration details.

## Access

The dashboard is available at [https://{% if minio.domain %}{{ minio.domain }}{% else %}{{ minio.subdomain + "." + domain }}{% endif %}/](https://{% if minio.domain %}{{ minio.domain }}{% else %}{{ minio.subdomain + "." + domain }}{% endif %}/) or [http://{% if minio.domain %}{{ minio.domain }}{% else %}{{ minio.subdomain + "." + domain }}{% endif %}/](http://{% if minio.domain %}{{ minio.domain }}{% else %}{{ minio.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ minio.subdomain + "." + tor_domain }}/](http://{{ minio.subdomain + "." + tor_domain }}/)
{% endif %}
