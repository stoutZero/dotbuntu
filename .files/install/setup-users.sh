setup_users () {
  if [ "" = "$1" ]; then
    echo "Please supply a hostname, or just use the old one"
    exit 1
  fi

  sudo git clone https://github.com/stoutZero/dotbuntu /dotbuntu

  if [ ! -d /home/pl ]; then
    sudo adduser --gecos "" --shell $(which zsh) pl
    sudo usermod -aG sudo pl
    [ -d ~/.ssh ] && sudo cp -an ~/.ssh ~pl/
    sudo mkdir ~pl/tmp
    sudo chown -R pl: ~pl
  fi

  if [ -f /home/pl/.git/config ]; then
    sudo su pl -c 'git -C ~/ remote set-url origin /dotbuntu'
  else
    sudo su pl -c 'git config --global --add safe.directory /dotbuntu/.git'
    sudo su pl -c 'git clone /dotbuntu ~/dotbuntu'
    sudo su pl -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
    sudo su pl -c 'rm -rf ~/dotbuntu'
  fi

  if [ ! -f /etc/sudoers.d/pl ]; then
    echo 'pl ALL=(ALL) NOPASSWD:ALL' \
      | sudo tee /etc/sudoers.d/pl > /dev/null

    sudo visudo -f /etc/sudoers.d/pl

    [ $? -eq 1 ] && sudo rm -f /etc/sudoers.d/pl
  fi

  if [ ! -d /home/deployer ]; then
    sudo adduser --gecos "" --shell $(which zsh) deployer
    [ -d ~/.ssh ] && sudo cp -an ~/.ssh ~deployer/
    sudo mkdir ~deployer/tmp
    sudo chown -R deployer: ~deployer
  fi

  if [ -f /home/deployer/.git/config ]; then
    sudo su deployer -c 'git -C ~/ remote set-url origin /dotbuntu'
  else
    sudo su deployer -c 'git config --global --add safe.directory /dotbuntu/.git'
    sudo su deployer -c 'git clone /dotbuntu ~/dotbuntu'
    sudo su deployer -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
    sudo su deployer -c 'rm -rf ~/dotbuntu'
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

  echo 'printing git remote for ~deployer'
  sudo su deployer 'git -C ~ remote get-url origin'
  echo
  echo

  echo 'printing git remote for ~pl'
  sudo su pl 'git -C ~ remote get-url origin'
  echo
  echo

  echo "Done, try: ssh as pl. Current user: $(whoami)"
}
