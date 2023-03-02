# Graylog

[Graylog](https://www.graylog.org/) Graylog is a leading centralized log management solution built to open standards for capturing, storing, and enabling real-time analysis of terabytes of machine logs.

## Access

It is available at [https://graylog.{{ domain }}/](https://graylog.{{ domain }}/) or [http://graylog.{{ domain }}/](http://graylog.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://graylog.{{ tor_domain }}/](http://graylog.{{ tor_domain }}/)
{% endif %}

## Security 
  - To enable https_only or auth set the service config to True
`settings/config.yml`
```
graylog:
  https_only: True
  auth: True
```

  - pwsecret:
    -  Quoting current docs: You MUST set a secret that is used for password encryption and salting. The server will refuse to start if it’s not set. Use at least 64 characters. If you run multiple graylog-server nodes, make sure you use the same password_secret for all of them!
*Generate a secret with for example:*  `pwgen -N 1 -s 96`

## Usage:

You have to manually create the needed inputs in Graylog, the container ports are mapped as follow:

- Graylog web interface and REST API 9000 (disabled, proxied by Traefik)
- Netflow 2055
- Beats 5044
- Syslog TCP 1514
- Syslog UDP 1514
- GELF TCP 12201
- GELF UDP 12201


## How to receive docker logs:

Logs from all containers:
```
{
  "log-driver": "gelf",
  "log-opts":  {
    "gelf-address": "udp://url.homelab:12201",
    "tag": "docker: name"
  }
}
```

To receive logs from a container ( docker-compose method), add this to the compose file in the container you want to log, this goes at the same ident level as labels and volumes.

```
    logging:
      driver: "gelf"
      options:
        gelf-address: "udp://graylog.example.com:12201"
        tag: "first-logs"

```


Another option is to use [Logspout](https://github.com/gliderlabs/logspout) which adds more features and dont disable json logger, which is needed for example by 'docker logs' command.  