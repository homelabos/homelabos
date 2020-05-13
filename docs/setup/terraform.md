# Terraform

HomelabOS can spin up cloud servers for you if you don't have physical
hardware servers you can use at your house.

## Digital Ocean

Create a DO account, login, click `API` on the left menu, and generate a
new access token. Name it `Terraform`, save it, and copy the value into
you `settings/vault.yml` file under `do_access_token:`. If the file looks garbled, make sure you run `make decrypt`.

If you are already using DO you may receive an error around your SSH key
already existing. Login to DO, go to the Security page, and delete the SSH
key. Terraform will re-add it and then know how to manage it correctly.

## Running Terraform

Run `make terraform`

## Destroying Terraform Resources

Run `make terraform_destroy` to destroy the resources Terraform created.

## Common Problems

### 422 SSH Key is already in use on your account

You have already added your SSH key to your account, so Terraform can't manage it properly.

Run `ssh-keygen -l -E md5 -f ~/.ssh/id_rsa.pub` then go to your DO dashboard, click your photo in the top right, then Profile. Now click Security, find the key that matches the fingerprint that was output by the command given, and delete it. Now run `make terraform` again.
