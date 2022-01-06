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