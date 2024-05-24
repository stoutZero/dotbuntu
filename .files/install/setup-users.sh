setup_users () {
  if [ "" = "$1" ]; then
    echo "Please supply a hostname, or just use the old one"
    exit 1
  fi

  sudo git clone https://github.com/stoutZero/dotbuntu /dotbuntu

  sudo adduser --gecos "" --shell $(which zsh) pl
  sudo usermod -aG sudo pl
  sudo cp -an ~/.{f,g,z}* ~pl
  sudo cp -an .ssh ~pl/
  sudo chown -R pl: ~pl

  if [ -f /home/pilus/.git/config ]; then
    sudo su pl -c 'git -C ~/ remote set-url origin /dotbuntu'
  else
    sudo su pl -c 'git clone /dotbuntu ~/dotbuntu'
    sudo su pl -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
    sudo su pl -c 'rm -rf ~/dotbuntu'
  fi

  echo 'pl ALL=(ALL) NOPASSWD:ALL' \
    | sudo tee /etc/sudoers.d/pl > /dev/null
  sudo visudo -f /etc/sudoers.d/pl

  sudo adduser --gecos "" --shell $(which zsh) deployer
  sudo cp -an ~/.{f,g,z}* ~deployer
  sudo cp -an .ssh ~deployer/
  sudo chown -R deployer: ~deployer

  if [ -f /home/deployer/.git/config ]; then
    sudo su deployer -c 'git -C ~/ remote set-url origin /dotbuntu'
  else
    sudo su deployer -c 'git clone /dotbuntu ~/dotbuntu'
    sudo su deployer -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
    sudo su deployer -c 'rm -rf ~/dotbuntu'
  fi

  sudo chsh -s $(which zsh) root
  sudo cp -an ~/.{f,g,z}* /root/
  sudo cp -an .ssh /root/
  sudo chown -R root: /root/

  if [ -f /root/.git/config ]; then
    sudo su root -c 'git -C ~/ remote set-url origin /dotbuntu'
  else
    sudo su root -c 'git clone /dotbuntu ~/dotbuntu'
    sudo su root -c 'mv ~/dotbuntu/.{f,g,z}* ~/'
    sudo su root -c 'rm -rf ~/dotbuntu'
  fi

  echo 'printing git remote for ~root'
  sudo cat /root/.git/config
  echo
  echo

  echo 'printing git remote for ~pl'
  sudo cat /home/pl/.git/config
  echo
  echo

  echo 'printing git remote for ~pl'
  sudo cat /home/pl/.git/config
  echo
  echo

  echo "Done, try: ssh as pl. Current user: $(whoami)"
}
