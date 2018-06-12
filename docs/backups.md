# Backups

HomelabOS backs itself up to any S3 compatible storage out of the box using [Restic](https://restic.net/).

## Set up your own S3

We recommend Minio.

```
brew install minio/stable/minio
minio server /data
```

Create a bucket called `homelabos`.

Set your S3 path and keys in `host_vars/myserver`.

If you use minio for your S3 hosting, your s3_path should look something like `s3:http://192.168.1.212:9000/homelabos/`

Once these are set, HomelabOS will back up all it's core data every night.

To back up your NAS and data on it is beyond the scope of this document.