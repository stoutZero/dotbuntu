#!/usr/bin/env zsh

sudo apt install -y curl ca-certificates

if [ ! -d /usr/share/postgresql-common/pgdg ]; then
  sudo install -d /usr/share/postgresql-common/pgdg
fi

if [ ! -f /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc ]; then
  sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail \
    https://www.postgresql.org/media/keys/ACCC4CF8.asc
fi

if [ ! -f /etc/apt/sources.list.d/pgdg.list ]; then
  sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

  sudo apt update
fi

echo 'installing postgresql-16'
echo

sudo apt -y install postgresql-16

echo
echo 'postgresql-16 installed'
