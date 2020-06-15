# Samba

[Samba](https://download.samba.org/pub/samba/stable/) Export your HLOS storage_dirs as CIFS/SMB file shares

## Access

This container exposes your {{storage_dir}}/* folders as a SMB/CIFS (Windows file sharing) network share.

You can connect to it using windows, linux and mac via

```
smb://{{default_username}}@{{homelab_ip}}/HomelabOS
```
