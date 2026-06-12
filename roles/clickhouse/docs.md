# ClickHouse

[ClickHouse](https://clickhouse.com/) is an open source columnar OLAP database for real-time analytics on large datasets.

## Access

The HTTP interface is available at [https://{% if clickhouse.domain %}{{ clickhouse.domain }}{% else %}{{ clickhouse.subdomain + "." + domain }}{% endif %}/](https://{% if clickhouse.domain %}{{ clickhouse.domain }}{% else %}{{ clickhouse.subdomain + "." + domain }}{% endif %}/) or [http://{% if clickhouse.domain %}{{ clickhouse.domain }}{% else %}{{ clickhouse.subdomain + "." + domain }}{% endif %}/](http://{% if clickhouse.domain %}{{ clickhouse.domain }}{% else %}{{ clickhouse.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ clickhouse.subdomain + "." + tor_domain }}/](http://{{ clickhouse.subdomain + "." + tor_domain }}/)
{% endif %}

The native TCP protocol is exposed on port `{{ clickhouse.native_port | default("9000") }}` for `clickhouse-client` and native drivers.

## Connection

Use the credentials stored in `settings/passwords/clickhouse_password`. The default username is `{{ clickhouse.username | default("clickhouse") }}`.

Example HTTP query:

```
curl "https://{% if clickhouse.domain %}{{ clickhouse.domain }}{% else %}{{ clickhouse.subdomain + "." + domain }}{% endif %}/?query=SELECT%201"
```

Example native client from the server:

```
clickhouse-client --host localhost --port {{ clickhouse.native_port | default("9000") }} --user {{ clickhouse.username | default("clickhouse") }} --password <password>
```

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
clickhouse:
  https_only: True
  auth: True
```
