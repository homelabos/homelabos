echo "Current setting value: "
sudo docker run -it -v ${PWD}:/workdir mikefarah/yq yq r settings/config.yml $1
