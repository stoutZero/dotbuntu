#!/usr/bin/env bash
get_platform () {
  echo $(uname -s | tr '[:upper:]' '[:lower:]')
}

get_arch () {
  echo $(dpkg --print-architecture)
}

get_release () {
  echo "$(lsb_release -sr)"
}
