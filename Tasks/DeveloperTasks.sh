#!/usr/bin/env bash

# Run linting scripts
Task::lint(){
  highlight "Linting"
  Task::run_docker pip install yamllint; find . -type f -name '*.yml' | sed 's|\./||g' | egrep -v '(\.kitchen/|\[warning\]|\.molecule/)' | xargs yamllint -c yamllint.conf -f parsable

}
