# How HomelabOS uses Storage

## Understanding storage types and their uses

There are 3 kinds of storage related to Docker and Docker compose. And by extension, HomelabOS.

- Ephemeral - This storage disappears when the container is shut down. It's used for things like temp storage for a containers services.

- Volume - These are mounted by the container and 'map' a physical (host, ubuntu) directory, to a containers internal directory. Volumes are used for persistent storage. For instance, Mysql's DB storage directories are mapped to host folders so that even if the container restarts, the db's storage exists when it restarts. You'll see these referenced in docker-compose.yml files like this:

  ```yml
  volumes:
    - /var/homelabos/serviceName:/MyFiles
  ```

  This mapping of a volume means that the container, and it's software can access the contents of `/var/homelabos/serviceName` by accessing it's own `/MyFiles` directory.

- NAS - Network Attached Storage volume(s) - NAS Volumes - are volumes, but they're controlled, in part, by HomelabOS. If you enable NAS storage in your config, and provide valid credentials to your NAS, HomelabOS will take care of mounting your NAS for you.

## Understanding Collection Auto-Volumes

HomelabOS provides a number of services designed to act on, or share, collections of data. For instance, Airsonic is designed to provide you a web interface to your music collection. But Airsonic isn't alone. Jellyfin, Plex and Funkwhale all provide that same access to your music collection. To enable these services to share access to a common collection of media (or documents, etc.) HomelabOS understand, and maintains a series of collection folders that are auto-mapped by docker when the service is brought online. HomelabOS uses the following Collection Auto-volumes

- Backups
- Books
- Documents
- Downloads
- Music
- Pictures
- temp
- Video

In general, if it makes sense for a HomelabOS service to have access to a given collection, you'll find that it's automatically set up for you. For instance, out of the box, Airsonic has access to the Music volume, and Nextcloud has access to the Documents volume.

These folders are maintained by HomelabOS inside the directory specified by the `storage_dir` configuration variable.

## Understanding the `storage_dir` config variable

Your settings/config.yml file contains a variable named `storage_dir` that defaults to the directory `/mnt/nas`.

> Despite the name, this folder _does not have to be a NAS Mount_.

If you're not using a NAS, because you've got an external hard drive attached, or an internal raid array you've already mounted that's fine. Just set the `storage_dir` config variable to the directory where you have mounted your storage.

Whenever you enable a service, HomelabOS verifies that the storage_dir contains directories that match the collection auto-volumes mentioned above.

> Setting up and mounting storage is a complex and potentially destructive task. It is outside the scope of this document to help you mount your storage on your Homelab server. Please research, and be careful.

### Migrating storage

At some point, you may need to change where your `storage_dir` points, either because you've run out of space, or moved to a NAS. The following are high-level instructions on _what_ you need to do to migrate your data from one storage asset to another.

1. Run `systemctl stop docker` _on your HomelabOS server_ to disable all HomelabOS services that might try to read or write to your existing storage directory
2. Mount your new storage somewhere other than `/mnt/nas` perhaps `/media/newHd`.
3. Copy or Move the contents of your `/mnt/nas` directory to the newly mounted directory.
4. Edit your. `settings/config.yml` and change `storage_dir` to point at the newly mounted directory.
5. Run `systemctl start docker` _on your HomelabOS server_ to reenable docker
6. Run `make update` to re-deploy HomelabOS with the new storage_dir set.

## Understanding NAS configuration for HomelabOS

HomelabOS has a NAS section in the `settings/config.yml` file. This allows you to specify the connection details and credentials to accees your NAS. These details are used _in conjunction with the `storage_dir` variable_ to create and maintain `/etc/fstab` entries.

**HomelabOS is configured to write `/etc/fstab` entries that mount your NAS folders within, _or on top of_ the `storage_dir` directory** Be careful not to mount your NAS folders _over_ existing files in your `storage_dir` or you'll be very confused.

Your NAS options are:

- Setting `nas_enable` to `True` means that HomelabOS will start maintaining the mounting of your NAS for you, _after you run make update_
- `nas_host`: this is the IP or hostname of your NAS server/device. ie: 192.168.1.130
- `nas_mount_type`: your options here are `nfs`, `cifs`, or `smb`. While Ubuntu can mount just about anything, HomelabOS only knows how to maintain those three connection types.
- `nas_share_path`: this represents the path to the shared directory on your NAS.
- `nas_user`: username to authenticate with. \*defaults to the value of `default_username`
- `nas_pass`: password to authenticate with.
- `nas_workgroup`: Workgroup needed for some SMB/CIFS shares.
