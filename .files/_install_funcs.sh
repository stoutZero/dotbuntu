# shellcheck disable=SC2148

get_arch () {
  # shellcheck disable=SC2005
  echo "$(dpkg --print-architecture)"
}

get_hw () {
  # shellcheck disable=SC2005
  echo "$(uname -i)"
}

get_platform () {
  # shellcheck disable=SC2005
  echo "$(uname -s | tr '[:upper:]' '[:lower:]')"
}

get_release () {
  # shellcheck disable=SC2005
  echo "$(lsb_release -sr)"
}

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
  ppa="$1"

  count="$(grep -ri "$ppa" /etc/apt/sources.list.d | wc -l 2>/dev/null)"
  RETVAL=$?

  if [[ RETVAL != 0 ]]
  then
    echo 0
    exit -1
  fi

  echo count
}
