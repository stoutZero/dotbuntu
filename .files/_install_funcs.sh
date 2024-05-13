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
