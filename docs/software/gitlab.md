# Gitlab

[Gitlab](https://docs.gitlab.com/) "the single application for the entire DevOps lifecycle".

## Access

It is available at [https://gitlab.{{ domain }}/](https://gitlab.{{ domain }}/) or [http://gitlab.{{ domain }}/](http://gitlab.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://gitlab.{{ tor_domain }}/](http://gitlab.{{ tor_domain }}/)
{% endif %}

After the initial setup, for your first access, you can login with the default username `root` and the password has been created in your `settings/passwords/gitlab_root_password`

### SSH Port
{{ gitlab.ssh_port }} - defaults to 223, can be adjusted
- Default is 223
- Adjust in settings/config.yml
