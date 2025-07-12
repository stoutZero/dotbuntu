#!/usr/bin/env zsh

# shellcheck disable=SC2148

_printf () { printf "${1}\033[0m" }
_info () { printf "\033[34mℹ ${1}\n" } # BLUE TEXT
_warn () { printf "\033[1;31m⚠ ${1}\n" } # BOLD RED TEXT
_error () { printf "\033[1;31m✘ ERROR: ${1}\n" } # BOLD RED TEXT
_success () { printf "\033[1;32m✔ ${1}\n" } # BOLD GREEN TEXT

# @description Run a command after printing a message. Prints "DONE" when command succeeds, else error message & command output.
# @arg $1 string Phrase for prompting to text
# @arg $2 string Phrase for prompting to text
# @example
#   _run 'echo $OSTYPE' 'Printing the OS type'
_run () {
  if [ -z "${1}" ]; then
    _error "ERROR: No commands given"
    return 0
  fi

  if [ ! -z "${2}" ]; then
    _printf "${2} ... "
  else
    _printf "Running: ${1} ... "
  fi

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

check_ppa () {
  if [ -z "$1" ]; then
    _error "ERROR: No PPA name given"
    return 0
  fi

  count="$(grep -ri "$1" /etc/apt/sources.list.d | wc -l 2>/dev/null)"
  RETVAL=$?

  if [[ $RETVAL != 0 ]]
  then
    echo 0
    return 0
  fi

  echo count
}

# returns amd64
get_arch () {
  # shellcheck disable=SC2005
  echo "$(dpkg --print-architecture)"
}

get_distro () {
  # Figure out the current operating system to handle some
  # OS specific behavior.
  # '$OSTYPE' typically stores the name of the OS kernel.
  case "$OSTYPE" in
    *-musl) echo 'musl' ;;
    linux*) echo 'linux' ;;
    solaris*) echo 'solaris' ;;
    msys*|cygwin*) echo 'windows' ;;
    darwin*) echo 'darwin' ;;
    freebsd*) echo 'freebsd' ;;
    openbsd*) echo 'openbsd' ;;
    netbsd*) echo 'netbsd' ;;
    *) echo 'unknown' ;;
  esac
}

# returns x86_64, aarch64, armv7l, etc.
get_hw () {
  # shellcheck disable=SC2005
  echo "$(uname -i)"
}

# returns linux, darwin, etc.
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

gh_latest () {
  [ -z "${1}" ] && return 1

  curl -s "https://api.github.com/repos/${1}/releases/latest" | jq -r '.tag_name'
}

install_keyring () {
  if [ ! -d /etc/apt/keyrings ]; then
    _run 'sudo install -m 0755 -d /etc/apt/keyrings' \
      'Ensuring keyrings dir exists ... '
  fi
}

line_in_file () {
  line="$1"
  file="$2"

  echo $(grep "$line" "$file" 2>/dev/null | wc -l)
}
