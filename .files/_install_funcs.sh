#!/usr/bin/env bash
get_platform () { "$(uname -s | tr '[:upper:]' '[:lower:]')" ; }

get_hw () { uname -i ; }

get_arch () { "$(dpkg --print-architecture)" ;  }

get_release () { "$(lsb_release -sr)" ; }

get_release_name () { "$(lsb_release -sc)" ; }

install_keyring () {
  if [ ! -d /etc/apt/keyrings ]; then
    echo 'ensuring keyrings dir exists'
    echo

    sudo install -m 0755 -d /etc/apt/keyrings

    echo
    echo 'keyrings dir exists'
  fi
}
