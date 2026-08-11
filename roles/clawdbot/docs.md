# Clawdbot

[Clawdbot](https://github.com/clawdbot/clawdbot) is a personal AI assistant you run on your own devices.

## Notes

Clawdbot expects a locally built Docker image. Build and tag it as `clawdbot:local`, or set `clawdbot.version` to match your tag.

You can set a gateway token with `clawdbot.gateway_token` (recommended for remote clients). The gateway binds with `--bind lan` by default.

## Access

It is available at [https://{% if clawdbot.domain %}{{ clawdbot.domain }}{% else %}{{ clawdbot.subdomain + "." + domain }}{% endif %}/](https://{% if clawdbot.domain %}{{ clawdbot.domain }}{% else %}{{ clawdbot.subdomain + "." + domain }}{% endif %}/) or [http://{% if clawdbot.domain %}{{ clawdbot.domain }}{% else %}{{ clawdbot.subdomain + "." + domain }}{% endif %}/](http://{% if clawdbot.domain %}{{ clawdbot.domain }}{% else %}{{ clawdbot.subdomain + "." + domain }}{% endif %}/)

The Gateway listens on port {{ clawdbot.port | default(18789) }} and the Bridge listens on port {{ clawdbot.bridge_port | default(18790) }}.

{% if enable_tor %}
It is also available via Tor at [http://{{ clawdbot.subdomain + "." + tor_domain }}/](http://{{ clawdbot.subdomain + "." + tor_domain }}/)
{% endif %}
