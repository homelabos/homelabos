# GoModel

[GoModel](https://github.com/ENTERPILOT/GoModel) is a fast, self-hosted AI gateway and LLM proxy that exposes OpenAI-compatible and Anthropic-compatible APIs. It sits between your applications and cloud or local AI model providers, providing routing, load balancing, failover, caching, cost tracking, budgets, rate limits, and observability from one endpoint. It is a lightweight, self-hosted [LiteLLM](https://litellm.ai) alternative.

The Docker image comes from [enterpilot/gomodel](https://hub.docker.com/r/enterpilot/gomodel).

## Features

- Multi-provider AI gateway: OpenAI, Anthropic, Google Gemini, Vertex AI, Azure OpenAI, Amazon Bedrock, Cohere, DeepSeek, Groq, xAI, OpenRouter, Ollama, vLLM, and more through a single API.
- OpenAI and Anthropic API compatibility (Chat Completions, Responses API, Messages API, embeddings, audio, files, batches, and realtime APIs). Use the official SDKs by changing the base URL.
- Virtual models, load balancing, retries, circuit breakers, provider health checks, and automatic failover.
- Response caching, cost tracking, budgets, rate limits, managed API keys, guardrails, and an MCP gateway.
- Built-in admin dashboard and Prometheus metrics.

## Setup

After enabling and deploying GoModel, open the admin dashboard at:

```
https://{% if gomodel.domain %}{{ gomodel.domain }}{% else %}{{ gomodel.subdomain + "." + domain }}{% endif %}/admin/dashboard
```

GoModel uses your HomelabOS OpenAI API key to reach upstream providers. Set the key in your vault (`settings/vault.yml`) under `vault.gomodel.openai_api_key`, for example:

```
vault:
  gomodel:
    openai_api_key: your-openai-key
```

The log format can be configured with `settings/config.yml`:

```
gomodel:
  log_format: text   # or json
```

## Using the API

GoModel exposes an OpenAI/Anthropic-compatible API. Point your application at the service's base URL and use the GoModel-generated API keys from the dashboard. For example, with curl:

```bash
curl https://{% if gomodel.domain %}{{ gomodel.domain }}{% else %}{{ gomodel.subdomain + "." + domain }}{% endif %}/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your-gomodel-api-key" \
  -d '{
    "model": "gpt-4o-mini",
    "messages": [{"role": "user", "content": "Say hello in one sentence."}]
  }'
```

## Data

GoModel state and usage data persist at `{{ volumes_root }}/gomodel/data` (mounted at `/app/data` in the container).

## Access

It is available at [https://{% if gomodel.domain %}{{ gomodel.domain }}{% else %}{{ gomodel.subdomain + "." + domain }}{% endif %}/](https://{% if gomodel.domain %}{{ gomodel.domain }}{% else %}{{ gomodel.subdomain + "." + domain }}{% endif %}/) or [http://{% if gomodel.domain %}{{ gomodel.domain }}{% else %}{{ gomodel.subdomain + "." + domain }}{% endif %}/](http://{% if gomodel.domain %}{{ gomodel.domain }}{% else %}{{ gomodel.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ gomodel.subdomain + "." + tor_domain }}/](http://{{ gomodel.subdomain + "." + tor_domain }}/)
{% endif %}
