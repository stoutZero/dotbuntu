#!/usr/bin/env zsh

# shellcheck disable=SC2148

_info () {
  echo ; echo
  echo "${fg_bold[blue]}[INSTALLER]${reset_color} $1"
  echo ; echo
}

_error () {
  echo ; echo
  echo "${fg_bold[red]}[INSTALLER:ERROR]${reset_color} $1"
  echo ; echo
}

# returns amd64
get_arch () {
  # shellcheck disable=SC2005
  echo "$(dpkg --print-architecture)"
}

# returns x86_64
get_hw () {
  # shellcheck disable=SC2005
  echo "$(uname -i)"
}

# returns linux
get_platform () {
  # shellcheck disable=SC2005
  echo "$(uname -s | tr '[:upper:]' '[:lower:]')"
}

# returns 18.04, 22.04, etc.
get_release () {
  # shellcheck disable=SC2005
  echo "$(lsb_release -sr)"
}

# returns bionic, focal, jammy, etc.
get_release_name () {
  # shellcheck disable=SC2005
  echo "$(lsb_release -sc)"
}

install_keyring () {
  if [ ! -d /etc/apt/keyrings ]; then
    echo 'ensuring keyrings dir exists'
    echo

    sudo install -m 0755 -d /etc/apt/keyrings

    echo
    echo 'keyrings dir exists'
  fi
}

check_ppa () {
  count="$(grep -ri "$1" /etc/apt/sources.list.d | wc -l 2>/dev/null)"
  RETVAL=$?

  if [[ $RETVAL != 0 ]]
  then
    echo 0
    exit -1
  fi

  echo count
}

line_in_file () {
  line="$1"
  file="$2"

  echo $(grep "$line" "$file" 2>/dev/null | wc -l)
}
