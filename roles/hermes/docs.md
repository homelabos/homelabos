# Hermes

[Hermes](https://hermes-agent.nousresearch.com/) is a self-hosted, self-improving AI agent with an optional [web UI](https://github.com/nesquena/hermes-webui) that runs the agent in-process. It persists memory across sessions, learns skills from experience, runs scheduled jobs, and can be used from the web UI or connected to messaging platforms like Telegram, Discord, Slack, and WhatsApp. It works with any LLM provider (OpenAI, Anthropic, Google, OpenRouter, DeepSeek, or your own endpoint).

## Access

It is available at [https://{% if hermes.domain %}{{ hermes.domain }}{% else %}{{ hermes.subdomain + "." + domain }}{% endif %}/](https://{% if hermes.domain %}{{ hermes.domain }}{% else %}{{ hermes.subdomain + "." + domain }}{% endif %}/) or [http://{% if hermes.domain %}{{ hermes.domain }}{% else %}{{ hermes.subdomain + "." + domain }}{% endif %}/](http://{% if hermes.domain %}{{ hermes.domain }}{% else %}{{ hermes.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ hermes.subdomain + "." + tor_domain }}/](http://{{ hermes.subdomain + "." + tor_domain }}/)
{% endif %}

## Notes

- The web UI is protected by a password, which defaults to the main HomelabOS `default_password`. Set `hermes.webui_password` in `settings/config.yml` to override it.
- On first launch the web UI will prompt you to configure a provider and model. Add your API key in **Settings → Providers**.
- Hermes data (config, sessions, skills, and memory) is stored in `{{ volumes_root }}/hermes/hermes-home`.
- The workspace shown in the file browser lives at `{{ volumes_root }}/hermes/workspace`.
- Conversations, memory, and skills are self-hosted and never leave your server unless you opt into a cloud provider.
