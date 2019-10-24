echo "Old setting value: "
sudo docker run -it -v ${PWD}:/workdir mikefarah/yq yq r settings/config.yml $1
sudo docker run -it -v ${PWD}:/workdir mikefarah/yq yq w -i settings/config.yml $1 $2
echo "New setting value: "
sudo docker run -it -v ${PWD}:/workdir mikefarah/yq yq r settings/config.yml $1 $2