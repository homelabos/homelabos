#!/bin/bash

docker run --rm -it -v $(pwd):/data cytopia/yamllint -c yamllint.conf .
