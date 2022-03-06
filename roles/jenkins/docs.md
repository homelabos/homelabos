# Jenkins

[Jenkins](https://www.jenkins.io/) The leading open source automation server, Jenkins provides hundreds of plugins to support building, deploying and automating any project.

## Adding packages

In some situations you might want to include extra packages in your Jenkins installation.

To do this set `additional_packages` under the jenkins section of the config.
```yaml
jenkins:
  additional_packages: ['package1', 'package2']
```


## Access

It is available at [https://{% if jenkins.domain %}{{ jenkins.domain }}{% else %}{{ jenkins.subdomain + "." + domain }}{% endif %}/](https://{% if jenkins.domain %}{{ jenkins.domain }}{% else %}{{ jenkins.subdomain + "." + domain }}{% endif %}/) or [http://{% if jenkins.domain %}{{ jenkins.domain }}{% else %}{{ jenkins.subdomain + "." + domain }}{% endif %}/](http://{% if jenkins.domain %}{{ jenkins.domain }}{% else %}{{ jenkins.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ jenkins.subdomain + "." + tor_domain }}/](http://{{ jenkins.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
jenkins:
  https_only: True
  auth: True
```
