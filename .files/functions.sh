# shellcheck disable=SC2148
# SC2148: Tips

_completemarks () {
  # shellcheck disable=SC2034,SC2207
  reply=($(ls "$MARKPATH"))
}

port() {
  # Print usage instructions if no arguments are supplied
  if [ $# -eq 0 ]; then
    echo "Usage: port PORT"
    echo ""
    echo "Examples:"
    echo "  ports 80   - Filter by target port 80"
    return 0
  fi

  ports "${1}"
}
ports() {
  # Print usage instructions if help flag is supplied or no arguments are supplied
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ports"
    echo "     ports [PORT | SEARCH_TERM]"
    echo "     ports [PORT] [SEARCH_TERM]"
    echo "     ports [-h | --help]"
    echo ""
    echo "Examples:"
    echo "  ports    - List all listening ports"
    echo "  ports 80   - Filter by target port 80"
    echo "  ports nginx  - Search/highlight rows matching 'nginx'"
    echo "  ports 443 root - Filter by port 443 and highlight 'root'"
    echo "  ports -h   - Show this help message"
    return 0
  fi

  local target_port=""
  local search_term=""

  # Argument handling logic
  if [ $# -eq 1 ]; then
    # Check if the single argument is purely an integer
    if [[ "$1" =~ ^[0-9]+$ ]]; then
      target_port="$1"
    else
      search_term="$1"
    fi
  elif [ $# -ge 2 ]; then
    target_port="$1"
    search_term="$2"
  fi

  local ss_cmd=("sudo" "ss" "-tunlp")

  # Filter natively by source (listening) port if provided
  if [ -n "$target_port" ]; then
    ss_cmd+=("sport = :$target_port")
  fi

  # Print the table header
  printf "%-8s %-12s %-24s %-10s %-35s %-30s\n" \
    "PROTO" "STATE" "LOCAL ADDRESS" "USER" "PROCESS" "FD_CWD"
  printf "%s\n" "------------------------------------------------------------------------------------------------------------------------"

  # Execute ss and process lines
  "${ss_cmd[@]}" 2>/dev/null | awk 'NR > 1 {
    print $1, $2, $5, $0
  }' | while read -r proto state local full_line; do
    
    # Extract PID and FD from the process info column
    pid=$(echo "$full_line" | grep -oP 'pid=\K[0-9]+' | head -n 1)
    fd=$(echo "$full_line" | grep -oP 'fd=\K[0-9]+' | head -n 1)
    
    if [ -n "$pid" ] && [ -d "/proc/$pid" ]; then
      proc_user=$(ps -o user= -p "$pid" 2>/dev/null | tr -d ' ')
      proc_path=$(readlink -f "/proc/$pid/exe" 2>/dev/null || echo "unknown")
      proc_cwd=$(readlink -f "/proc/$pid/cwd" 2>/dev/null || echo "unknown")
    else
      proc_user="unknown"
      proc_path="unknown"
      proc_cwd="unknown"
      pid="N/A"
      fd="N/A"
    fi

    process_col="(${pid}) ${proc_path}"
    fd_cwd_col="(${fd}) ${proc_cwd}"

    # Format row line
    row_output=$(printf "%-8s %-12s %-24s %-10s %-35s %-30s" \
      "$proto" "$state" "$local" "$proc_user" "$process_col" "$fd_cwd_col")

    # Apply search term filtering and highlight matching terms if provided
    if [ -n "$search_term" ]; then
      if echo "$row_output" | grep -qi "$search_term"; then
        echo "$row_output" | sed -E "s/($search_term)/\x1b[1;31m\1\x1b[0m/gi"
      fi
    else
      echo "$row_output"
    fi
  done
}

psg () { pgrep -x "${1}" | xargs -r ps -o user,pid,time,args -p ; }

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
  result="$(printf '%s' "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";
  #                       └─ default (when `--mathlib` is used) is 20
  #
  if [[ "$result" == *.* ]]; then
    # improve the output for decimal numbers
    printf '%s' "$result" |
    sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
        -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
        -e 's/0*$//;s/\.$//';  # remove trailing zeros
  else
    printf '%s' "$result";
  fi;
  printf "\n";
}

# Get a character’s Unicode code point
codepoint () {
  perl -e "use utf8; print sprintf('U+%04X', ord(\"$*\"))";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

# Create a data URL from a file
dataurl () {
  local mimeType
  mimeType=$(file -b --mime-type "$1");
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

ducks () { du -cksh "${1:-.}"/* | sort -rh | head -n "${2:-5}"; }

# Use Git’s colored diff when available
unalias diff 2>/dev/null
diff () {
  git diff --no-index --color-words "$@"
}

# UTF-8-encode a string of Unicode symbols
escape () {
  printf "\\\x%s" "$(printf '%s' "$@" | xxd -p -c1 -u)";
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

  if [ "$#" -gt 0 ]; then
    du $arg -- "$@";
  else
    du $arg -- .[^.]* *;
  fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames () {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified."
    return 1
  fi

  local domain
  domain="${1}"
  echo "Testing ${domain}…"
  echo "" # newline

  local tmp
  tmp=$(echo -e "GET / HTTP/1.0\nEOT" | openssl s_client -connect "${domain}:443" 2>&1)

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText

    certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_header, no_serial, no_version, \
      no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
      echo "Common Name:"
      echo "" # newline
      echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
      echo "" # newline
      echo "Subject Alternative Name(s):"
      echo "" # newline
      echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
        | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
      return 0
  else
    echo "ERROR: Certificate not found."
    return 1
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

  if command -v python3 ; then
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python3 -c $'import http.server;\nmap = http.server.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in list(map.items()):\n    map[key] = value + ";charset=UTF-8";\n    http.server.test();' "${port}";
  elif command -v python ; then
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n  map[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "${port}";
  elif command -v php ; then
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

  numfmt --to=iec-i --suffix=B --padding=7 "${input}"
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
  # shellcheck disable=SC2012
  \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# Create a new directory and enter it
mkd () {
    # Check if an argument was actually provided
    if [ $# -eq 0 ]; then
        echo "Error: No directory specified." >&2
        return 1
    fi

    # Try to create the directories
    if ! mkdir -p "$@"; then
        echo "Error: Failed to create directory." >&2
        return 1
    fi

    # Get the last argument in the list to cd into
    # shellcheck disable=SC2124
    local last_dir="${@:-1}"

    # Try to change directory
    if ! cd "$last_dir"; then
        echo "Error: Failed to change directory to '$last_dir'." >&2
        return 1
    fi
}

netsize () {
  local _size
  local human

  _size="$(curl -sIL "$1" | grep -i '^Content-Length: ' | cut -d' ' -f2 | tr -d '\r')"
  human="$(humane_bytes "$_size" | tr -d '[:space:]')"

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
  # shellcheck disable=SC2124
  local tmpFile="${@%/}.tar";
  tar -cf "${tmpFile}" --exclude=".DS_Store" --exclude="._*" "${@}" || return 1;

  # GNU `stat`
  size=$(stat -c"%s" "${tmpFile}" 2> /dev/null);

  local cmd="";
  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli";
  else
    if command pigz 2> /dev/null; then
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

  _cmd="tar -cf --exclude=\".DS_Store\" --exclude=\"._*\" - ${1} | brotli";

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
  _cmd="tar -cf --exclude=\".DS_Store\" --exclude=\"._*\" - '${1}' | ${_zst} > '${outFile}'";

  echo -n "Compressing '${1}' into '${outFile}' with zstd (cores: ${_c}, comp: ${_z})... ";

  eval "$_cmd"

  echo "DONE";
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre () {
  if command -v eza &>/dev/null ; then
    eza --follow-symlinks --long --classify --group --all --header --links --tree
  elif command -v tree &>/dev/null ; then
    tree -aC -I '.git|bower_components|node_modules|vendor' --dirsfirst "$@" | less -FRNX
  else
    echo "Cannot find commands tree or eza, exiting..."
    exit 1
  fi
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode () {
  # shellcheck disable=SC2145
  perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

unmark () { rm -i "$MARKPATH/$1" ; }

pwdx () { sudo lsof -a -d cwd -p "$1" -n -Fn | awk '/^n/ {print substr($0,2)}' ; }

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

sen () { sudo systemctl "enable" "$@" ; }
sdi () { sudo systemctl "disable" "$@" ; }
is_en () { sudo systemctl "is-enabled" "$@" ; }
sdrel () { sudo systemctl daemon-reload ; }
start () { sudo systemctl "start" "$@" ; }
status () { sudo systemctl "status" "$@" ; }
stop () { sudo systemctl "stop" "$@" ; }
reload () { sudo systemctl "reload" "$@" ; }
restart () { sudo systemctl "restart" "$@" ; }

list_svc () {
  sudo systemctl list-units --type=service --all | cat
}

if command -v compctl>/dev/null ; then
  compctl -K _completemarks jump
  compctl -K _completemarks unmark
fi
