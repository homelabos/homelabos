# Terraform

HomelabOS can spin up cloud servers for you if you don't have physical
hardware servers you can use at your house.

## Digital Ocean

Create a DO account, login, click `API` on the left menu, and generate a
new access token. Name it `Terraform`, save it, and copy the value into
you `settings/vault.yml` file under `do: access_token:`. If the file looks garbled, make sure you run `make decrypt`.

If you are already using DO you may receive an error around your SSH key
already existing. Login to DO, go to the Security page, and delete the SSH
key. Terraform will re-add it and then know how to manage it correctly.

