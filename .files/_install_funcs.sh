#!/usr/bin/env zsh

# shellcheck disable=SC2148

_printf () {
  msg="${1}"
  color=""

  if [ -z "$2" ]; then
    color="${fg_bold[$2]}"
  fi

  printf "${color}$1${reset_color}"
}

_info () {
  echo "${fg_bold[blue]}${1}${reset_color}"
}

_error () {
  echo "${fg_bold[red]}${1}${reset_color}"
}

_success () {
  echo "${fg_bold[green]}${1}${reset_color}"
}

_run () {
  if [ -z "${1}" ]; then
    _error "ERROR: No commands given"
    return 0
  fi

  _print "${2} ... "

  lines=$(eval "${1}")

  if [ $? -eq 0 ]; then
    _success 'DONE'
  else
    _error 'FAILED'
    _error 'Command that has been run:'
    _error "${1}"
    _error 'Complete command output:'
    _error "${lines}"
  fi
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

gh_latest () {
  [ -z "${1}" ] && exit 1

  curl -s "https://api.github.com/repos/${1}/releases/latest" | jq -r '.tag_name'
}
