if [ ! -d /dotbuntu ]; then
  sudo git clone https://github.com/stoutZero/dotbuntu /dotbuntu
else 
  sudo git -C /dotbuntu pull
fi

if [ ! -d /home/pilus ]; then
  sudo adduser --gecos "" --shell $(which zsh) pilus
  sudo usermod -aG sudo pilus
  [ -d ~/.ssh ] && sudo cp -an ~/.ssh ~pilus/
  sudo mkdir ~pilus/tmp
  sudo chown -R pilus: ~pilus
fi

if [ -f /home/pilus/.git/config ]; then
  sudo su pilus -c 'git -C ~/ remote set-url origin /dotbuntu'
else
  sudo su pilus -c 'git config --global --add safe.directory /dotbuntu/.git'
  sudo su pilus -c 'git clone /dotbuntu ~/dotbuntu'
  sudo su pilus -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
  sudo su pilus -c 'rm -rf ~/dotbuntu'
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
  sudo mkdir ~ops/tmp
  sudo chown -R ops: ~ops
fi

if [ -f /home/ops/.git/config ]; then
  sudo su ops -c 'git -C ~/ remote set-url origin /dotbuntu'
else
  sudo su ops -c 'git config --global --add safe.directory /dotbuntu/.git'
  sudo su ops -c 'git clone /dotbuntu ~/dotbuntu'
  sudo su ops -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
  sudo su ops -c 'rm -rf ~/dotbuntu'
fi

sudo chsh -s $(which zsh) root
sudo cp -an ~/.{f,g,z}* /root/
[ -d ~/.ssh ] && sudo cp -an ~/.ssh /root/
sudo mkdir /root/tmp
sudo chown -R root: /root/

if [ -f /root/.git/config ]; then
  sudo su root -c 'git -C ~/ remote set-url origin /dotbuntu'
else
  sudo su root -c 'git config --global --add safe.directory /dotbuntu/.git'
  sudo su root -c 'git clone /dotbuntu ~/dotbuntu'
  sudo su root -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
  sudo su root -c 'rm -rf ~/dotbuntu'
fi

echo 'printing git remote for ~root'
sudo su root 'git -C ~ remote get-url origin'
echo
echo

echo 'printing git remote for ~ops'
sudo su ops 'git -C ~ remote get-url origin'
echo
echo

echo 'printing git remote for ~pl'
sudo su pl 'git -C ~ remote get-url origin'
echo
echo

echo "Done, try: ssh as pl. Current user: $(whoami)"
