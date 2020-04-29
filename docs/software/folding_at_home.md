# Folding@home

[Folding@home](https://hub.docker.com/r/johnktims/folding-at-home) Folding@home software allows you to share your unused computer power with scientists researching diseases.

## Install

make set folding_at_home.enable true
make

## Access

A dashboard is available at http://{{ homelab_ip }}:7396

## Settings

In `settings/config.yml` you can edit several settings included `power` which says how hard it will work.

The `team` setting defaults to the [HomelabOS Folding@home team](https://stats.foldingathome.org/team/261443). Join us in the fight against disease!

