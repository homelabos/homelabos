# HomelabOS Backups

HomelabOS automatically backs itself in a smart, incremental, encrypted way to any S3 compatible storage provider, using [Restic](https://restic.net/).

This is in addition to and separate from the Backup service included within HomelabOS, which backs up your personal computers to the HomelabOS servers.

## Get access to an S3 Bucket

Ideally you want your backups to be offsite, so an S3 bucket is not set up by default for you on your HomlabOS machine. Since we use encrypted backups, you can easily have a friend or enemy host an S3 server for you, and as long as they don't get your backup password, everything will be safe. We recommend generating a very secure password for your backup password.

Or you could pay Amazon and use their S3 service, if you're into that sort of thing.

## Set up your own S3 

We recommend Minio.

```
brew install minio/stable/minio
minio server /data
```

Create a bucket called `homelabos`.

Of course keep in mind when self hosting your own S3, you likely want to keep good backups of the S3 data files as well.

## Configure the Backup Service

Set your S3 path and keys in `host_vars/myserver`.

If you use minio for your S3 hosting, your s3_path should look something like `s3:http://192.168.1.212:9000/homelabos/`

Once these are set, HomelabOS will back up all it's core data every night at 4 AM.

## Restoring Backups

Let's say your machine gets wiped, or you want to migrate to a new machine. To restore your most recent backup, simply run `make restore`. Then proceed with the normal install step of running `make` and boom, you have all your data back with a fully working HomelabOS setup.