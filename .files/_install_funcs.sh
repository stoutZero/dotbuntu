#!/usr/bin/env bash
get_platform () {
  "$(uname -s | tr '[:upper:]' '[:lower:]')"
}

get_arch () {
  "$(dpkg --print-architecture)"
}

get_release () {
  "$(lsb_release -sr)"
}
