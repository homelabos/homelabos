# Submitting Merge Requests

When a Merge Request is ready to go, add the label `Ready for Review`.

Only Merge Requests with this label will be reviewed for inclusion. Any Merge
Requests submitted with this label that around found to not be ready for merge
during the review, will have the label removed. Make the changes/fixes requested
then add the label back to the Merge Request to be considered during the next
review session.

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

## Working locally on the documentation

Follow the [MkDocs Material Theme setup directions](https://squidfunk.github.io/mkdocs-material/getting-started/).

Then run `mkdocs serve`.

To build changes to the docs run `make docs`.

## Working locally on the website

To work on the [HomelabOS webiste](https://homelabos.com/) just type `make web` to serve it locally.
