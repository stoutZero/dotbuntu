#!/usr/bin/env zsh

if ! id -u deployer > /dev/null 2>&1; then
  echo 'creating user: deployer'
  sudo groupadd -g 10000 deployer

  sudo useradd \
    -g deployer --no-user-group \
    --home-dir /home/deployer \
    --shell "$(which zsh)" \
    --system --uid 10000 deployer
fi

if [ ! -d /home/deployer/apps ]; then
  echo 'creating app dir in ~deployer'
  sudo mkdir -p /home/deployer/apps
fi

if [ ! -f /home/deployer/.zshd/README.md ]; then
  echo 'copying .zshd to ~deployer'
  sudo cp -an ~/.{files,git,zsh}* /home/deployer/
fi

sudo chown -Rh deployer: /home/deployer

if [ ! -f /home/deployer/.nvm/README.md ]; then
  echo 'installing nvm as deployer'
  sudo su deployer  -l \
    -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash' \
    2>/dev/null
fi

if [ ! -d /home/deployer/.nvm/versions/node ]; then
  echo 'installing latest lts nodejs as deployer'
  sudo su deployer -l -c 'source ~/.zshrc ; nvm install --lts'
fi

if ! ls -1 /home/deployer/.nvm/versions/node/*/bin/ni > /dev/null 2>&1; then
  echo 'installing npm package: @antfu/ni as deployer'
  sudo su deployer -l -c 'source ~/.zshrc ; npm install -g @antfu/ni'
fi

if [ ! -f /home/deployer/.local/share/pnpm/pnpm ]; then
  echo 'installing pnpm as deployer'
  sudo su deployer -l -c 'curl -fsSL https://get.pnpm.io/install.sh | sh -'
fi
