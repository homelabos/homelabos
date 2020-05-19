# Contribution Guidelines

## Overview of project's development workflow

HomelabOS follows a common Open Source Software development workflow. A core group of maintainers handle the branching, merging and tagging of releases. While this core group shepherds the overall project, everyone is welcome to contribute. This document goes into detail on how you can contribute.

## Contribution overview - the _'what'_

While the rest of this document details how to contribute, this overview section is the 'what' not the 'how' of contributing. To contribute a bug fix, service, or enhancement you'll need to:

1. Establish and maintain a mirrored Fork
2. Branch Dev in your fork
3. Develop your feature/fix
4. Commit to your branch on your fork
5. Create a cross-fork Merge Request

## Getting setup and contributing - the _'how'_

To set yourself up to contribute to HomelabOS, you'll need a working understanding of Git, and a Gitlab account. Those prequisites are left as an exercise to the reader.

1.  Create your own fork by clicking the "Fork" button at https://gitlab.com/NickBusey/HomelabOS: ![Fork button location](https://i.imgur.com/xUDZqP6.png)
2.  In your fork, goto Settings/Repository -> "Mirroring repositories" and setup mirroring of NickBusey/HomelabOS
    ![Screen Shot of Mirror setup](https://imgur.com/lhCHCbF.png)

        Mirror direction = Pull
        Only mirror protected branches = enabled

3.  Then set your Protected Branches in Settings/Repository -> "Protected Branches" like this
    ![Setting Protected Branches](https://i.imgur.com/LbgrJuD.png)
    (you can ignore CODEOWNER though) you can even set push to "no one" so you can't accidentally push to that branch.

## Making a contribution

1. Make sure you don't have any outstanding un-related changes in your local repository with `git status`. You should see `nothing to commit, working tree clean`.
2. Create an issue in GitLab. From this issue, click the `Create Merge Request` button.
3. Now click the `Check Out Branch` button and copy Step 1, run that command on your local copy of the repository.
4. Now make your changes and commit and push them.
5. In GitLab, go to your Merge Request and make sure it is not labeled WIP and that all the check boxes are checked (If applicable).

Once you've submitted the MR it will be reviewed, and if it receives 2 approvals, it will be merged. If it needs changes, the maintainers will add commends describing the needed changes, add `WIP:` back to the start of the title, and assign it back to the submitter.

> If/When you are ask to rebase run:
> `git checkout dev` > `git pull` > `git checkout your-new-feature` > `git rebase dev`

## Working with Issues

### Labels

`enhancement` is for any issue that changes how HomelabOS itself deploys/operates.

`package` is for new packages people would like added to HomelabOS. These should not be marked as `enhancement`s.

`bug` is for bugs. :)

## Developing Locally with Vagrant

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
