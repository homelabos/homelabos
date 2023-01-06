#!/bin/bash

docker run --rm -v $(pwd):/data cytopia/yamllint -c yamllint.conf .
