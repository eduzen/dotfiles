# shellcheck disable=SC2148
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME"/.oh-my-zsh

ZSH_THEME="agnoster"

DEFAULT_USER=$USER

plugins=(
  git
  pip
  rust
  pyenv
  python
  kubectl
  extract
  ripgrep
  gcloud
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH"/oh-my-zsh.sh

# Brew
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]];
then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Enviroment Variables
[[ -f "$HOME"/.env ]] && source "$HOME"/.env
[[ -f "$HOME"/.extras ]] && source "$HOME"/.extras

# Aliases
[[ -f "$HOME"/.aliases ]] && source "$HOME"/.aliases

# Rust curl https://sh.rustup.rs -sSf | sh
[[ -f "$HOME"/.cargo/env ]] && source "$HOME"/.cargo/env

# GOLANG
[[ -f /usr/local/go/bin ]] && export PATH=$PATH:/usr/local/go/bin

# FuzzyFinder https://github.com/junegunn/fzf
[[ -f "$HOME"/.fzf.zsh ]] && source "$HOME"/.fzf.zsh


# Google
# The next line updates PATH for the Google Cloud SDK.
[[ -f "$HOME"/google-cloud-sdk/path.zsh.inc ]] && source "$HOME"/google-cloud-sdk/path.zsh.inc
# The next line enables shell command completion for gcloud.
[[ -f "$HOME"/google-cloud-sdk/completion.zsh.inc ]] && source "$HOME"/google-cloud-sdk/completion.zsh.inc


# Kubernetes
[[ -f "$HOME"/.kube/config ]] && export KUBECONFIG="$HOME"/.kube/config
[[ -f "$HOME"/.krew/receipts/krew.yaml ]] && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
[[ -f /usr/local/bin/stern ]] && source <(stern --completion=zsh)

# TILIX
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi


# Pyenv https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
if [[ -f "$HOME"/.pyenv/version ]]; then
    export PYENV_ROOT="$HOME"/.pyenv
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
    fi
fi

[[ -f /usr/local/go/bin ]] && export PATH=$PATH:/usr/local/go/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
