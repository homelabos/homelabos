# Network UPS Tools

[Network UPS Tools](https://networkupstools.org/) exposes locally attached UPS devices over the standard NUT protocol so Home Assistant and other clients can read power status.

## Access

This role runs on the host and exposes the NUT server on `{{ nut.listen_host | default(homelab_ip) }}:{{ nut.listen_port | default("3493") }}`.

To verify status directly on the host after deployment:

```bash
upsc {{ nut.ups_name | default("cyberpower") }}@localhost
```
