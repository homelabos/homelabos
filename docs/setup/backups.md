# HomelabOS Backups

HomelabOS automatically backs itself in a smart, incremental, encrypted way to any S3 compatible storage provider, using [Restic](https://restic.net/) and [Minio](https://minio.io/).

This is in addition to and separate from the Backup service included within HomelabOS, which backs up your personal computers to the HomelabOS servers.

## Get access to an S3 Bucket

Ideally you want your backups to be offsite, so really the best case scenario would be to find a friend also running HomelabOS, and trade S3 access with them.

Or you could pay Amazon and use their S3 service, if you're into that sort of thing.

## Use your own S3 

This method is not recommended as it is backing up to yourself which is not very useful. The usefulness here comes from Restic's snapshotting. So while this won't give you an offsite backup, it will still provide timed snapshots to access old versions of files.

View your logs for the Minio service (homelabos_minio_1) and copy the AccessKey and SecretKeys out of the logs. Put these into your `settings/vault.yml` file (run `make decrypt` to decrypt it first) under the `s3_access_key` and `s3_secret_key` variables. Now login to Minio at `https://{% if minio.domain %}{{ minio.domain }}{% else %}{{ minio.subdomain + "." + domain }}{% endif %}/` with the same access and secret key values and create a bucket called `restic-backups`. Finally run `make update` to copy your new settings up to your HomelabOS server.

Of course keep in mind when self hosting your own S3, you likely want to keep good backups of the S3 data files as well.

## Configure the Backup Service

Set your S3 keys in `host_vars/myserver`.

Once these are set, HomelabOS will back up all it's core data every night at 4 AM.

## Restoring Backups

Let's say your machine gets wiped, or you want to migrate to a new machine. To restore your most recent backup, simply run `make restore`. Then proceed with the normal install step of running `make` and boom, you have all your data back with a fully working HomelabOS setup.

Alternatively you can work directly with the Restic backups through it's Docker shell. Using either [Portainer](/software/portainer.md) or your server's CLI, once you gain access to the Restic shell, you can run commands like `restic snapshots` to list all your snapshots.

To restore just your NextCloud data for example, you can run `docker exec restic_restic_1 restic restore latest --include /data/nextcloud --target /data/nextcloud`.