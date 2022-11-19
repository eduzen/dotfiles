#!/usr/bin/env bash

platform='unknown'
unamestr=$(uname)

if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'FreeBSD' ]]; then
  platform='mac'
fi

echo
echo "### We are on ${platform}"
echo

if [[ ${platform} == 'linux' ]]; then
  sudo apt-get update && sudo apt-get upgrade -f

  sudo apt install \
    make \
    build-essential \
    libssl-dev \
    shellcheck \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    git \
    curl \
    python3-pip \
    exuberant-ctags \
    ack-grep \
    wget \
    zsh \
    ripgrep \
    openssh-server \
    openssl \
    bzip2 \
    ncurses-base \
    fail2ban \
    ufw \
    httpie
fi

echo
read -p "Do you want to configure ohmyzsh? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone "https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi


echo
read -p "Do you want to configure brew? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo
read -p "Do you want to configure vim? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  FILE=$HOME/.vimrc
  if [ ! -f "$FILE" ]; then
    wget "https://raw.githubusercontent.com/fisadev/fisa-vim-config/v12.0.1/config.vim" -O .vimrc
  fi
fi

echo
read -p "Do you want to configure cargo/just? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  FILE=$HOME/.cargo/env

  if [ ! -f "$FILE" ]; then
    curl https://sh.rustup.rs -sSf | sh
    cargo install just
  fi
fi

echo
read -p "Do you want to configure pyenv? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  FILE="$HOME"/.pyenv/version

  if [ ! -f "$FILE" ]; then
    rm -rf "$HOME"/.pyenv/
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  fi

  FILE="$HOME"/.pyenv/plugins/pyenv-virtualenv/README.md

  if [ ! -f "$FILE" ]; then
    rm -rf "$HOME"/.pyenv/plugins/pyenv-virtualenv
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)"/plugins/pyenv-virtualenv
  fi

  pyenv install 3.10.8

  pyenv global 3.10.8

  python -m pip install -U pip wheel
  python -m pip install -r "$HOME"/requirements.txt
fi

echo
read -p "Do you want to configure ufw/firewall? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  # for pi-hole
  sudo ufw allow 80/tcp
  sudo ufw allow 53/tcp
  sudo ufw allow 53/udp
  sudo ufw allow 67/tcp
  sudo ufw allow 67/udp
  sudo ufw allow 546:547/udp
fi

echo
read -p "Do you want to configure fzf? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi