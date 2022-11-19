export PYENV_ROOT="$HOME"/.pyenv
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
