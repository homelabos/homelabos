{% raw %}
# Upgrading Existing Serivce to use the new Includes

Original `tasks/main.yml` file for tick looked like this:

```
---
- name: Make tick directory.
  file:
    path: "{{ volumes_root }}/tick"
    state: directory

- name: Copy tick docker-compose.yml file into place.
  template:
    src: docker-compose.tick.yml.j2
    dest: "{{ volumes_root }}/tick/docker-compose.yml"
  vars:
    tor_domain: "{{ tor_http_domain_file.stdout | default('') }}"

- name: Configure telegraf
  template:
    src: telegraf.conf.j2
    dest: "{{ volumes_root }}/tick/telegraf.conf"

- name: Configure tick systemd service.
  template:
    src: service.j2
    dest: /etc/systemd/system/tick.service

- name: Start tick
  systemd:
    name: tick
    enabled: "yes"
    daemon-reload: "yes"
    state: started
```

The new style for the tick `tasks/main.yml` file looks like this:

```
---

- name: Setup {{service_item}}
  include: includes/setup.yml

- name: Configure telegraf
  template:
    src: telegraf.conf.j2
    dest: "{{ volumes_root }}/tick/telegraf.conf"

- name: Start {{service_item}}
  include: includes/start.yml
```

You can see we have 2 includes, `includes/setup.yml` and `includes/start.yml`. These handle everything that every service needs.

The only other step, configuring the telegraf.conf, is the only step not required for other services, so is the only extra step we need to add.

If a service has no other steps required beyond what is in setup.yml and start.yml, then the file can look simply like this:

```
---

- name: Setup {{service_item}}
  include: includes/setup.yml

- name: Start {{service_item}}
  include: includes/start.yml
```

Wheter or not extra steps are required is on a per service basis, and will require reading through the `tasks/main.yml` file for that service, and determining if any are present.

Moving to this style will greatly reduce our lines of code, as well as eliminate errors as everything will be much more consistent. It also improves how we deploy our documentation, due to new steps in `includes/setup.yml`.

If a service for some reason needs to _not_ do a step from `includes/setup.yml` or `includes/setup.yml`, simply don't include the includes for that service, and do what is needed instead.

## Upgrading to Self Contained Service Style

# Self Contained Services

HomelabOS is migrating to a self contained style of service.

This means that everything relating to a service should be within the folder of that service.

This allows new services to be added to the HomelabOS codebase by simply dropping in a new directory, and inversely removing services by removing it's directory.

## How To

### additional_configs.yml

Certain services require extra configuration values beyond the default configs that all services use.

The default configs are:

```
  enable: {{ ztncui.enable | default(enable_ztncui, None) | default(False) }}
  https_only: {{ ztncui.https_only | default(False) }}
  auth: {{ ztncui.auth | default(False) }}
  domain: {{ ztncui.domain| default(False) }}
  subdomain: {{ ztncui.subdomain | default("ztncui") }}
  version: {{ ztncui.version | default("latest") }}
```

enable, https_only, auth, domain, subdomain, and version.

Any extra configuration values for a service need to be migrated into a file called `additional_configs.yml` in the service folder (roles/SERVICENAME/)

The old configs can be found at https://gitlab.com/NickBusey/HomelabOS/-/blob/615a9b1f95a678f846600f28673c3274992a6688/roles/homelabos_config/templates/config.yml.j2

If a service has more than the 6 default configs listed above, they need migrated.

For example Zulip has:

```
  db_version: {{ zulip.db_version | default("latest") }}
  redis_version: {{ zulip.redis_version | default("latest") }}
  rabbit_version: {{ zulip.rabbit_version | default("3.7.7") }}
```

These have been migrated to roles/zulip/additional_configs.yml

This new file should have no empty new lines at the end, and should have 2 spaces at the start of each line.

If the service doesn't have any extra configs, this step can be skipped.

### Documentation migration

The documentation file for the service needs moved from software_docs/SERVICENAME.md to roles/SERVICENAME/docs.md

### service.yml

A new file `roles/SERVICENAME/service.yml` needs to be created for each new service.

It should look like:

```
---
full_service_name: Zulip Chat
description: Threaded chat software
category: chat
version: 2.0.2-0
```

This file is used to generate docs/index.md as well as roles/homelabos_config/templates/config.yml.j2.

Category should be one of the following: 

```
analytics
automation
blogging-platforms
calendaring-and-contacts-management
chat
docker-vm-management
document-management
e-books
email
federated-identityauthentication
feed-readers
file-sharing-and-synchronization
games
gateways-and-terminal-sharing
media-streaming
miscother
money-budgeting-and-management
monitoring
note-taking-and-editors
password-managers
personal-dashboards
photo-and-video-galleries
read-it-later-lists
social-networking
software-development
task-managementto-do-lists
vpn
web-servers
wikis
```

Version should be set to the value listed at https://gitlab.com/NickBusey/HomelabOS/-/blob/615a9b1f95a678f846600f28673c3274992a6688/roles/homelabos_config/templates/config.yml.j2

Running `go run main.go test --services SERVICENAME` will tell you if you did things correctly or not (for the most part, should still test deploy the service).

Assuming the service passes the test, run `go run main.go package` and now you should be able to deploy the service.

{% endraw %}
