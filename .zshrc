# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ZSH_THEME="agnoster"

DEFAULT_USER=$USER

plugins=(
  git
  pip
  rust
  just
  pyenv
  python
  kubectl
  extract
  ripgrep
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Enviroment Variables
[ -f "$HOME"/.zsh_env ] && source "$HOME"/.zsh_env
[ -f "$HOME"/.zshenv ] && source "$HOME"/.zshenv
[ -f "$HOME"/.cargo/env ] && source "$HOME"/.cargo/env

# Aliases
[ -f "$HOME"/.bash_aliases ] && source "$HOME"/.bash_aliases
[ -f "$HOME"/.zsh_aliases ] && source "$HOME"/.zsh_aliases
[ -f "$HOME"/.zshaliases ] && source "$HOME"/.zshaliases

[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh
[ -f "$HOME"/.just.zsh ] && source "$HOME"/.just.zsh
[ -f /usr/local/bin/stern ] && source <(stern --completion=zsh)


export PYENV_ROOT="$HOME/.pyenv"
if [[ -f $PYENV_ROOT ]]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
    export PATH="$PYENV_ROOT/bin:$PATH"
if

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
