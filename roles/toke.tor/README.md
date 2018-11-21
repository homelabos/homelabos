# Tor Hidden Services

A role to configure tor hidden services.

Can be found on [ansible-galaxy](https://galaxy.ansible.com/toke/tor/).

## Requirements

_None._

## Role Variables

##### ***Mandatory***:
_None._

##### ***Optional***:
| Name               | Description                                    | Default Value |
| :---               | :----------                                    | :------------ |
| tor_user           | User under which tor is running                | debian-tor    |
| tor_group          | Group associated with the tor user             | debian-tor    |
| tor_become         | whether to become root during the installation | true          |
| tor_config_dir     | Tor configuration file directory               | /etc/tor      |
| tor_control_port   | If set use it as tor control port              | _None_        |
| tor_data_directory |                                                | /var/lib/tor  |
| tor_password       | Password for control port                      | _None_        |
| tor_root_group     | Group of the root-User                         | root          |
| hidden_services    | List of services to be set up                  | _None_        |

##### ***Hidden service***
* **dir**: Directory to store the hidden service configuration. 
* **port**: Port to expose to the TOR-Network
* **source**: The ip-address and port of the service to be exposed.
* *version*: When defined used as a hidden service version (usually not set or 3)


## Dependencies

_None._

## Example Playbook

```yaml
- hosts: tor
  roles:
  - role: toke.tor
    hidden_services:
    - dir: /var/lib/tor/ssh-onion
      port: 22
      source: 127.0.0.1:22
    - dir: /var/lib/tor/ssh-onion_v3
      port: 22
      source: 127.0.0.1:22
      version: 3
    - dir: /var/lib/tor/https-onion
      port: 443
      source: 127.0.0.1:443
```

## License

MIT License

## Author Information

* [Toke](https://github.com/toke)
* [Madonius](https://github.com/madonius)
