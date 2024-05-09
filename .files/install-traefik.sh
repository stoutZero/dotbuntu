#!/usr/bin/env bash


if [ ! -f /usr/local/bin/traefik ]; then
  cd /tmp/

  v=v3.0.0

  arch="$(dpkg --print-architecture)"

  platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  prefix="${v}_${platform}_${arch}"

  wget "https://github.com/traefik/traefik/releases/download/${v}/traefik_${prefix}.tar.gz"

  tar xzf "traefik_${prefix}.tar.gz"

  sudo mv traefik /usr/local/bin/
fi

sudo chown root:root /usr/local/bin/traefik
sudo chmod 755 /usr/local/bin/traefik

sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/traefik

sudo groupadd -g 321 traefik
sudo useradd \
  -g traefik --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 321 traefik

sudo mkdir /etc/traefik
sudo mkdir /etc/traefik/acme
sudo chown -R root:root /etc/traefik
sudo chown -R traefik:traefik /etc/traefik/acme


sudo tee /etc/traefik/traefik.toml > /dev/null <<EOT
# Configuration sample for Traefik v2.
# From: https://github.com/traefik/traefik/blob/master/traefik.sample.toml

# Global configuration
[global]
  checkNewVersion = true
  sendAnonymousUsage = true

# Entrypoints configuration

# Entrypoints definition
#
# Optional
# Default:
[entryPoints]
  [entryPoints.web]
    address = ":80"

  [entryPoints.websecure]
    address = ":443"

# Traefik logs configuration

# Traefik logs
# Enabled by default and log to stdout
#
# Optional
#
[log]
  # Log level
  #
  # Optional
  # Default: "ERROR"
  #
  # level = "DEBUG"

  # Sets the filepath for the traefik log. If not specified, stdout will be used.
  # Intermediate directories are created if necessary.
  #
  # Optional
  # Default: os.Stdout
  #
  # filePath = "log/traefik.log"

  # Format is either "json" or "common".
  #
  # Optional
  # Default: "common"
  #
  # format = "json"

# Access logs configuration

# Enable access logs
# By default it will write to stdout and produce logs in the textual
# Common Log Format (CLF), extended with additional fields.
#
# Optional
#
# [accessLog]

  # Sets the file path for the access log. If not specified, stdout will be used.
  # Intermediate directories are created if necessary.
  #
  # Optional
  # Default: os.Stdout
  #
  # filePath = "/path/to/log/log.txt"

  # Format is either "json" or "common".
  #
  # Optional
  # Default: "common"
  #
  # format = "json"

# API and dashboard configuration
# Enable API and dashboard
[api]
  # Enable the API in insecure mode
  #
  # Optional
  # Default: false
  #
  # insecure = true

  # Enabled Dashboard
  #
  # Optional
  # Default: true
  #
  # dashboard = false

# Ping configuration
# Enable ping
[ping]
  # Name of the related entry point
  #
  # Optional
  # Default: "traefik"
  #
  # entryPoint = "traefik"

# Docker configuration backend
# Enable Docker configuration backend
[providers.docker]
  # Docker server endpoint. Can be a tcp or a unix socket endpoint.
  #
  # Required
  # Default: "unix:///var/run/docker.sock"
  #
  # endpoint = "tcp://10.10.10.10:2375"

  # Default host rule.
  #
  # Optional
  # Default: "Host(`{{ normalize .Name }}`)"
  #
  # defaultRule = "Host(`{{ normalize .Name }}.docker.localhost`)"

  # Expose containers by default in traefik
  #
  # Optional
  # Default: true
  #
  # exposedByDefault = false
EOT

sudo chown root:root /etc/traefik/traefik.toml
sudo chmod 644 /etc/traefik/traefik.toml

sudo tee /etc/systemd/system/traefik.service > /dev/null <<EOT
[Unit]
Description=traefik proxy
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Restart=on-abnormal

; User and group the process will run as.
User=traefik
Group=traefik

; Always set "-root" to something safe in case it gets forgotten in the traefikfile.
ExecStart=/usr/local/bin/traefik --configfile=/etc/traefik/traefik.toml

; Limit the number of file descriptors; see \`man systemd.exec\` for more limit settings.
LimitNOFILE=1048576

; Use private /tmp and /var/tmp, which are discarded after traefik stops.
PrivateTmp=true

; Use a minimal /dev (May bring additional security if switched to 'true', but it may not work on Raspberry Pi's or other devices, so it has been disabled in this dist.)
PrivateDevices=true

; Hide /home, /root, and /run/user. Nobody will steal your SSH-keys.
ProtectHome=true

; Make /usr, /boot, /etc and possibly some more folders read-only.
ProtectSystem=full

; … except /etc/ssl/traefik, because we want Letsencrypt-certificates there.
;   This merely retains r/w access rights, it does not add any new. Must still be writable on the host!
ReadWriteDirectories=/etc/traefik/acme

; The following additional security directives only work with systemd v229 or later.
; They further restrict privileges that can be gained by traefik. Uncomment if you like.
; Note that you may have to add capabilities required by any plugins in use.
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOT

sudo chown root:root /etc/systemd/system/traefik.service
sudo chmod 644 /etc/systemd/system/traefik.service

sudo systemctl daemon-reload

sudo systemctl enable traefik.service

# sudo systemctl start traefik.service

echo "Traefik service has been installed and enabled, but it's not started automatically."
echo "You should do that yourself when convenient."
