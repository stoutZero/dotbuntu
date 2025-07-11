 # shellcheck disable=SC2148
# SC2148: Tips

_completemarks () { reply=($(ls $MARKPATH)) ; }

function port { sudo lsof -P -i ":${1}" }

psg () {
  ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")
}

ee () {
  if [ "" = "${1}" ]; then
    echo "No file supplied, exiting."
    exit 1
  fi

  truncate -s0 "${1}"
  $EDITOR "${1}"
}

# Simple calculator
calc () {
  local result="";
  result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";
  #                       └─ default (when `--mathlib` is used) is 20
  #
  if [[ "$result" == *.* ]]; then
    # improve the output for decimal numbers
    printf "$result" |
    sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
        -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
        -e 's/0*$//;s/\.$//';  # remove trailing zeros
  else
    printf "$result";
  fi;
  printf "\n";
}

# Get a character’s Unicode code point
codepoint () {
  perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

# Create a data URL from a file
dataurl () {
  local mimeType=$(file -b --mime-type "$1");
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8";
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# http://www.cyberciti.biz/tips/unix-linux-bash-shell-script-wrapper-examples.html
# Name: _getdomainnameonly
# Arg: Url/domain/ip
# Returns: Only domain name
# Purpose: Get domain name and remove protocol part, username:password and other parts from url
_domainname () {
  # get url
  local h="$1"

  # upper to lowercase
  # shellcheck disable=SC2155
  local f="$(echo "$h" | tr '[:upper:]' '[:lower:]')"

  # remove protocol part of hostname
  f="${f#http://}"
  f="${f#https://}"
  f="${f#ftp://}"
  f="${f#scp://}"
  f="${f#scp://}"
  f="${f#sftp://}"

  # Remove username and/or username:password part of hostname
  f="${f#*:*@}"
  f="${f#*@}"

  # remove all /foo/xyz.html*
  f=${f%%/*}

  # show domain name only
  echo "$f"
}

# Run `dig` and display the most useful info
digga () {
  dig +nocmd "$1" any +multiline +noall +answer
}

ducks () { du -cksh "${1:-.}"/* | sort -rh | head -n ${2:-5}; }

# Use Git’s colored diff when available
unalias diff 2>/dev/null
diff () {
  git diff --no-index --color-words "$@"
}

# UTF-8-encode a string of Unicode symbols
escape () {
  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi
}

# Determine size of a file or total size of a directory
fs () {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* *;
  fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames () {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified.";
    return 1;
  fi;

  local domain="${1}";
  echo "Testing ${domain}…";
  echo ""; # newline

  local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
    | openssl s_client -connect "${domain}:443" 2>&1);

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_header, no_serial, no_version, \
      no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux");
      echo "Common Name:";
      echo ""; # newline
      echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//";
      echo ""; # newline
      echo "Subject Alternative Name(s):";
      echo ""; # newline
      echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
        | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
      return 0;
  else
    echo "ERROR: Certificate not found.";
    return 1;
  fi
}

gh_latest () {
  # shellcheck disable=SC2005
  echo "$(gh release list -R "${1}" --exclude-pre-releases -L 1 --json 'tagName' | jq '.[0].tagName' | sed 's/\"//g')"
}

gh_dl () {
  if [[ "" == "${1}" ]] || [[ "" == "${2}" ]]; then
    cat << EOF
Usage: gh_dl <REPO> <PATTERN>

e.g.: gh_dl https://github.com/sharkdp/bat "bat_*_amd64.deb"

EOF
    exit 1
  fi

  repo="${1}"
  pattern="${2}"

  latest="$(gh_latest "$repo")"

  gh release download \
    -R "${repo}" \
    -p "${pattern}" \
    "${latest}"

  echo "${latest}"
}

# # Compare original and gzipped file size
# gz () {
#   local origsize=$(wc -c < "$1");
#   local gzipsize=$(gzip -c "$1" | wc -c);
#   local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
#   printf "orig: %d bytes\n" "$origsize";
#   printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
# }

# Start an HTTP server from a directory, optionally specifying the port
http_serve () {
  local port="${1:-8000}";
  sleep 3 && open "http://localhost:${port}/" &

  if [ command -v python3 ] ; then
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python3 -c $'import http.server;\nmap = http.server.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in list(map.items()):\n    map[key] = value + ";charset=UTF-8";\n    http.server.test();' "${port}";
  elif [ command -v python ]; then
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n  map[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "${port}";
  elif [ command -v php ]; then
    php -S "127.0.0.1:${port}"
  else
    echo "Cannot find python (v2) / python3 / php, exiting!"

    exit 1
  fi
}

humane_bytes () {
  if [ "$#" -gt 0 ]; then
    input=$(prinft %s "$@")
  else
    input=$1
  fi

  echo $(numfmt --to=iec-i --suffix=B --padding=7 $input)
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json () {
  if [ -t 0 ]; then # argument
    python3 -mjson.tool <<< "$*" | pygmentize -l javascript;
  else # pipe
    python3 -mjson.tool | pygmentize -l javascript;
  fi;
}

jump () {
  pushd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

mark () {
  mkdir -p "$MARKPATH"
  ln -s "$(pwd)" "$MARKPATH/$1"
}

marks () {
  \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# Create a new directory and enter it
mkd () { mkdir -p "$@" && cd "$@"; }

netsize () {
  local _size="$(curl -sIL $1 | grep -i '^Content-Length: ' | cut -d' ' -f2 | tr -d '\r')"
  local human="$(humane_bytes $_size | tr -d '[:space:]')"

  printf "%d bytes • ${human}\n" "${_size}"
}

npmls () {
  (npm ls --depth=0 "$@" | sed "s/[├─┬]//g") 2>/dev/null
}

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
phpserver () {
  local port="${1:-4000}";
  # local ip=$(ipconfig getifaddr en1);
  local ip='127.0.0.1';
  sleep 1 && open "http://${ip}:${port}/" &
  php -S "${ip}:${port}";
}

svc () {
  if [ "" = "${1}" ]; then
    service --status-all
  else
    systemctl "${1}"
  fi
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz () {
  local tmpFile="${@%/}.tar";
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

  # GNU `stat`
  size=$(stat -c"%s" "${tmpFile}" 2> /dev/null);

  local cmd="";
  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli";
  else
    if hash pigz 2> /dev/null; then
      cmd="pigz";
    else
      cmd="gzip";
    fi;
  fi;

  echo "Compressing .tar using \`${cmd}\`…";
  "${cmd}" -v "${tmpFile}" || return 1;
  [ -f "${tmpFile}" ] && rm "${tmpFile}";
  echo "${tmpFile}.gz created successfully.";
}

# Create a .tar.br archive, using `brotli` for compression
tarbr () {
  if [ $# -eq 0 ];then
    printf "No arguments specified.\nUsage:\n tarbr <directory> <COMPRESSION: 1..11>">&2

    return 1
  fi

  if [ ! -d "$1" ];then
    echo "Error: $1 is not a valid folder" 2>&1

    return 1
  fi

  local outFile="${1}.tar.br";

  _z="${2:-11}"

  _cmd="tar cf - ${1} | brotli";

  if [ "11" != "${_z}" ]; then
    _cmd="${_cmd} -${_z}"
  fi

  _cmd="${_cmd} > ${outFile}"

  echo -n "Compressing '${1}' into '${outFile}' with brotli, compression level: ${_z}... ";

  eval "$_cmd"

  echo "DONE";
}

# Create a .tar.zst archive, using `zstd` for compression
tarzst () {
  if [ $# -eq 0 ];then
    printf "No arguments specified.\nUsage:\n tarzst <directory> <CORES: 1..N> <COMPRESSION: 1..22>">&2

    return 1
  fi

  if [ ! -d "$1" ];then
    echo "Error: $1 is not a valid folder" 2>&1

    return 1
  fi

  local outFile="${1}.tar.zst";

  _c="${2:-1}"
  _z="${3:-3}"

  if [[ "$_z" -gt 19  ]]; then
    _z="--ultra -${_z}"
  else
    _z="-${_z}"
  fi

  _zst="zstd -T${_c} -z ${_z}"
  _cmd="tar cf - '${1}' | ${_zst} > '${outFile}'";

  echo -n "Compressing '${1}' into '${outFile}' with zstd (cores: ${_c}, comp: ${_z})... ";

  eval "$_cmd"

  echo "DONE";
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre () {
  tree -aC -I '.git|bower_components|node_modules|vendor' --dirsfirst "$@" | less -FRNX;
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode () {
  perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

unmark () { rm -i "$MARKPATH/$1" }

pwdx () {
  sudo lsof -a -d cwd -p "$1" -n -Fn | awk '/^n/ {print substr($0,2)}'
}

notify_discord () {
  if [ -z "$DISCORD_WEBHOOK" ]; then
    echo 'Error: DISCORD_WEBHOOK is empty'
    exit 1
  fi

  machine=$(hostname)
  user=$(whoami)
  HEADER="Machine: $(hostname), time: $(date +'%Y-%m-%d %H:%M:%S %z')\nMessage:"
  curl -X POST \
  -H "Content-Type: application/json" \
  -d "{\"user\":\"${user}@${machine}\",\"content\": \"$HEADER\n$1\"}" \
  "$DISCORD_WEBHOOK"
}

sshk () { ssh-keygen -t ed25519 -C "${1}" -f "${1}" ; }

sen () { sudo systemctl "enable" "$@" }
sdi () { sudo systemctl "disable" "$@" }
is_en () { sudo systemctl "is-enabled" "$@" }
sdrel () { sudo systemctl daemon-reload; }
start () { sudo systemctl "start" "$@" }
status () { sudo systemctl "status" "$@" }
stop () { sudo systemctl "stop" "$@" }
reload () { sudo systemctl "reload" "$@" }
restart () { sudo systemctl "restart" "$@" }
list_svc () { sudo systemctl list-units --type=service --all | cat; }

compctl -K _completemarks jump
compctl -K _completemarks unmark
