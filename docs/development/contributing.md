# Development Workflow

First make sure you don't have any outstanding un-related changes in your local repository with `git status`. You should see `nothing to commit, working tree clean`. Create an issue in GitLab. From this issue, click the `Create Merge Request` button. Now click the `Check Out Branch` button and copy Step 1, run that command on your local copy of the repository. Now make your changes and commit and push them. In GitLab, go to your Merge Request and make sure it is not labeled WIP and that all the check boxes are checked. It will be reviewed, and if it receives 2 approvals, it will be merged. If it needs changes, the maintainers will add commends describing the needed changes, add `WIP:` back to the start of the title, and assign it back to the submitter.

# Working with Issues

## Labels

`enhancement` is for any issue that changes how HomelabOS itself deploys/operates.

`package` is for new packages people would like added to HomelabOS. These should not be marked as `enhancement`s.

`bug` is for bugs. :)

## Developing Locally

You can play around with the stack locally without needing an actual server to spin it up against.
First run `make config` as normal. The local IP and SSH username are not used for Vagrant, so they can be
for your real server, or fake. For `What is the domain you have pointed at your Homelab server with ports 80 and 443?:`
enter `localhost`.

Now run `make develop` to spin up a local instance inside a Vagrant machine.
For easy access to the services run `vagrant ssh -c "cat {{ volumes_root }}/homelab_hosts"`. Append the output of this to your
machine's host file (usually `/etc/hosts`). Now you should be able to access http://servicename.localhost:2280/
where `servicename` is the name of any services you have enabled in `config.yml`.
If you make changes to the Ansible scripts you can run `make provision` to run them again.

To deploy just one service you can run `make update_one SERVICE_NAME` e.g. `make update_one zulip`

To run just one set of tags you can run `make tag TAG_NAME` e.g. `make tag tinc`

`[client]$ make web` - Spins up a development stack

`[client]$ make lint` - Run linting scripts

## Working locally on the documentation

To serve the docs locally run `make docs_local`.

## Working locally on the website

To work on the [HomelabOS webiste](https://homelabos.com/) just type `make web` to serve it locally.
