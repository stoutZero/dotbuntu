#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.files/functions.sh

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

arch="$(get_hw)"

URL=https://storage.googleapis.com/gvisor/releases
URL="$URL/release/latest/${ARCH}"

wget ${URL}/runsc ${URL}/runsc.sha512 \
  ${URL}/containerd-shim-runsc-v1 \
  ${URL}/containerd-shim-runsc-v1.sha512

sha512sum -c runsc.sha512 \
  -c containerd-shim-runsc-v1.sha512

rm -f *.sha512

chmod a+rx runsc containerd-shim-runsc-v1

sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin

/usr/local/bin/runsc install
sudo systemctl reload docker
docker run --rm --runtime=runsc hello-world
