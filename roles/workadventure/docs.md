# WorkAdventure

[WorkAdventure](https://workadventu.re/) is a web-based collaborative virtual office and meeting space.

HomelabOS deploys WorkAdventure from the upstream GitHub repository and adapts the upstream single-domain Docker Compose setup for the normal HomelabOS Traefik entrypoint.

## Access

Visit `{{ service_domain }}` after enabling the service.

## Notes

This role uses the upstream development Docker Compose workflow because WorkAdventure's published single-domain compose file is an override for the repository compose file. The role clones the WorkAdventure source into `{{ volumes_root }}/workadventure/app` before starting the containers.
