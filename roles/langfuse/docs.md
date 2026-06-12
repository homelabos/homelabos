# Langfuse

[Langfuse](https://langfuse.com) is an open source LLM engineering platform for observability, evaluations, and prompt management. It integrates with OpenTelemetry, LangChain, OpenAI SDK, LiteLLM, and more.

## Setup

After enabling and deploying Langfuse, open the web UI and create your first organization and project. Use the generated API keys in your LLM applications to send traces and metrics.

Point your SDKs at your HomelabOS instance:

```
https://{% if langfuse.domain %}{{ langfuse.domain }}{% else %}{{ langfuse.subdomain + "." + domain }}{% endif %}/
```

## Access

It is available at [https://{% if langfuse.domain %}{{ langfuse.domain }}{% else %}{{ langfuse.subdomain + "." + domain }}{% endif %}/](https://{% if langfuse.domain %}{{ langfuse.domain }}{% else %}{{ langfuse.subdomain + "." + domain }}{% endif %}/) or [http://{% if langfuse.domain %}{{ langfuse.domain }}{% else %}{{ langfuse.subdomain + "." + domain }}{% endif %}/](http://{% if langfuse.domain %}{{ langfuse.domain }}{% else %}{{ langfuse.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ langfuse.subdomain + "." + tor_domain }}/](http://{{ langfuse.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
langfuse:
  https_only: True
  auth: True
```
