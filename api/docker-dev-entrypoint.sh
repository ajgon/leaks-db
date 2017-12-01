#!/usr/bin/env bash

if [ ! -d "$APP_HOME/.ruby-advisory-db/.git" ]; then
  rm -rf "$APP_HOME/.ruby-advisory-db"
  git clone https://github.com/rubysec/ruby-advisory-db.git "$APP_HOME/.ruby-advisory-db"
fi

mkdir -p "$HOME/.local/share"
ln -s "$APP_HOME/.ruby-advisory-db" "$HOME/.local/share/ruby-advisory-db"
bundle-audit update
cd "$APP_HOME" && git init && git add -A && bundle exec overcommit --sign && overcommit --sign pre-commit

exec "$@"
