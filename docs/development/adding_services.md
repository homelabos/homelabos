# Adding Services to HomelabOS

## Before you Begin

Before you begin, please familiarize yourself with the [contributing](contributing.md) document.

Also, make sure the project meets our standards for inclusion.

* Services should be in development for at least a year.
* Services should be actively maintained. (Last commit within 6 months.)

## Adding a service

### Create Role Folder

Make the following folder structure
```
service_name
  tasks
  templates
```
In tasks add `main.yml` with the following content:
```
---

- name: Setup {{service_item}}
  include: includes/setup.yml

- name: Start {{service_item}}
  include: includes/start.yml

```
If the need additional setup steps, add them between the setup and start includes.

If the default setup and start steps don't work, remove the includes, copy/paste the contents of the included file, and modify as needed.

In templates/ add `docker-compose.servicename.yml.j2` and fill that out.
Look at other services as a reference.

### Create service.yml in the role folder
Contents in this format
```yaml
---
full_service_name: Airsonic
description: Airsonic is a free, web-based media streamer, providing ubiquitous access to your music.
project_url: https://airsonic.github.io/
category: media-streaming
version: latest
port: 4040
```

### Create a Documentation Page

Each service should have a `docs.md` file in it's folder.

### Review

You should have at the minimum the following files.
```
servicename/
  tasks/
    main.yml
  templates/
    docker-compose.servicename.yml.j2
  docs.md
  service.yml
```

## Test it
### Run the test tool
$ `go run main.go test`
Fix any issues.

### How to Debug a New Service

After a new service has been deployed, run `systemctl status SERVICE_NAME` to see
how it's doing.

If it's not running with an error like `(code=exited, status=1/FAILURE)`

Grab the value of the ExecStart line, and run it by hand. So if the ExecStart line looks like:
`ExecStart=/usr/bin/docker-compose -p zulip up`
then manually change directory `cd {{ volumes_root }}/zulip` and run the bit after the =, `/usr/bin/docker-compose -p zulip up` to see the error output directly.

## Finalize It
### Run Build Tool
$ `go run main.go package`
This will regenerate the `docs/index.md` file.

### Add Service to CHANGELOG.md

Add at the top of the file under the `Dev` section, rather than under the previous release.
