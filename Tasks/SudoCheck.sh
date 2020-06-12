#!/usr/bin/env bash

Task::sudo_check() {

  if [[ `whoami` = root ]]; then
    colorize red "*** Are you running this command with sudo? ***"
    colorize red "** You don't need to. Try again without sudo **"
    sleep 5
    exit
  fi
  }
