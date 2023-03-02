#!/bin/bash

docker run --rm -v $(pwd):/data:Z cytopia/yamllint -c yamllint.conf .
