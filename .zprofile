#!/usr/bin/env sh
unamestr=$(uname)

if [ "$unamestr" == 'Linux' ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ "$unamestr" == 'FreeBSD' ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$unamestr" == 'Darwin' ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -f "$HOME"/.pyenv/version ]; then
    export PYENV_ROOT="$HOME"/.pyenv
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

if [ -f /usr/bin/byobu-launch ]; then
  _byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
fi
