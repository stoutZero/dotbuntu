#!/usr/bin/env zsh

echo "Please make sure to run this script as root, or with sudo"
echo "Otherwise this script might fail horribly!"

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root, or with sudo"
   exit 1
fi

if [ ! -d /dotbuntu ]; then
  sudo git clone https://github.com/stoutZero/dotbuntu /dotbuntu
else 
  sudo git -C /dotbuntu pull
fi

if [ -f /root/.git/config ]; then
  git -C ~/ remote set-url origin /dotbuntu
else
  git config --global --add safe.directory /dotbuntu/.git
  git clone /dotbuntu ~/dotbuntu
  mv ~/dotbuntu/.files ~/
  mv ~/dotbuntu/.git* ~/
  mv ~/dotbuntu/.zsh* ~/
  rm -rf ~/dotbuntu
fi

sudo chsh -s $(which zsh) root
sudo mkdir /root/tmp &>/dev/null
sudo chown -R root: /root/

if [ ! -d /home/pilus ]; then
  sudo adduser --gecos "" --shell $(which zsh) pilus
  sudo usermod -aG sudo pilus
  [ -d ~/.ssh ] && sudo cp -an ~/.ssh ~pilus/
  sudo mkdir ~pilus/tmp &>/dev/null
  sudo chown -R pilus: ~pilus
fi

if [ -f /home/pilus/.git/config ]; then
  sudo \cp -a /root/.files /home/pilus/
  sudo \cp -a /root/.git* /home/pilus/
  sudo \cp -a /root/.zsh* /home/pilus/
  sudo chown pilus: /home/pilus/
  sudo su pilus -c 'git config --global --add safe.directory /dotbuntu/.git'
fi

if [ ! -f /etc/sudoers.d/pilus ]; then
  echo 'pilus ALL=(ALL) NOPASSWD:ALL' \
    | sudo tee /etc/sudoers.d/pilus > /dev/null

  sudo visudo -f /etc/sudoers.d/pilus

  [ $? -eq 1 ] && sudo rm -f /etc/sudoers.d/pilus
fi

if [ ! -d /home/ops ]; then
  sudo adduser --gecos "" --shell $(which zsh) ops
  [ -d ~/.ssh ] && sudo cp -an ~/.ssh ~ops/
  sudo mkdir ~ops/tmp &>/dev/null
  sudo chown -R ops: ~ops
fi

if [ -f /home/ops/.git/config ]; then
  sudo \cp -a /root/.files /home/ops/
  sudo \cp -a /root/.git* /home/ops/
  sudo \cp -a /root/.zsh* /home/ops/
  sudo chown ops: /home/ops/
  sudo su ops -c 'git config --global --add safe.directory /dotbuntu/.git'
fi

git config --global --add safe.directory /root
echo -n 'printing git remote for ~root: '
echo $(git -C /root remote get-url origin)

git config --global --add safe.directory /home/pilus
echo -n 'printing git remote for ~pilus: '
echo $(git -C /home/pilus remote get-url origin)

git config --global --add safe.directory /home/ops
echo -n 'printing git remote for ~ops: '
echo $(git -C /home/ops remote get-url origin)

echo "Done, try: ssh as pilus. Current user: $(whoami)"
