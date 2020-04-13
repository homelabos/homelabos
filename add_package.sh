#!/bin/bash

sudo docker run -v $(pwd):/data -d --name addPackage -it -w /data ruby bash
sudo docker exec addPackage bundle update --bundler
sudo docker exec addPackage bundle install
sudo docker exec -it addPackage ./bin/addPkg.rb
sudo docker stop addPackage
sudo docker rm addPackage
