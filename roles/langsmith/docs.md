# LangSmith

[LangSmith](https://www.langchain.com/langsmith) is a platform for LLM tracing, evaluation, and prompt management.

## Setup

Set `langsmith.license_key` in `settings/config.yml` (or via vault) if your deployment requires a license. You may also want to set `langsmith.initial_org_admin_email` and `langsmith.initial_org_admin_password` to bootstrap the first admin user.

## Access

The dashboard is available at [https://{% if langsmith.domain %}{{ langsmith.domain }}{% else %}{{ langsmith.subdomain + "." + domain }}{% endif %}/](https://{% if langsmith.domain %}{{ langsmith.domain }}{% else %}{{ langsmith.subdomain + "." + domain }}{% endif %}/) or [http://{% if langsmith.domain %}{{ langsmith.domain }}{% else %}{{ langsmith.subdomain + "." + domain }}{% endif %}/](http://{% if langsmith.domain %}{{ langsmith.domain }}{% else %}{{ langsmith.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ langsmith.subdomain + "." + tor_domain }}/](http://{{ langsmith.subdomain + "." + tor_domain }}/)
{% endif %}
