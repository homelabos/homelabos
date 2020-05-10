#!/bin/bash
# Decrypt vault
make decrypt

# Try to figure out where key is defined
FILE=settings/config.yml
SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r $FILE $1 $2)
if [ -z ${SETTING_VALUE} ]; then
    FILE=settings/vault.yml
    SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r $FILE $1 $2)
    if [ -z ${SETTING_VALUE} ]; then
        echo "Key does not exist in config.yml nor vault.yml."
        # Re-encrypt vault
        make encrypt
        exit 1
    fi
fi

echo "Current setting value: " ${SETTING_VALUE}

# Re-encrypt vault
make encrypt