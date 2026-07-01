# dotfiles

Chezmoi-managed terminal setup for macOS, Ubuntu, and Raspberry Pi.

Managed stack:

- zsh
- Starship
- tmux
- Ghostty on macOS
- eza, bat, ripgrep, fd, fzf, zoxide, delta, bottom, dust, procs
- just

## Bootstrap

### macOS

```sh
brew install chezmoi
chezmoi init --apply https://github.com/eduzen/dotfiles.git
```

### Ubuntu / Raspberry Pi OS

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/eduzen/dotfiles.git
```

## Local development

From a local clone:

```sh
chezmoi --source "$PWD" diff --exclude=scripts
chezmoi --source "$PWD" apply
exec zsh
```

## Private files

`.env` is intentionally not tracked. Chezmoi manages `~/.env` from `private_dot_env.tmpl` with private permissions and empty defaults for host-specific values. Put secrets such as Samba passwords in the local generated `~/.env`, not in Git.

Private aliases live in `~/.aliases_private` and are generated from `dot_aliases_private.tmpl`.

## Smoke test

```sh
tmux
starship explain
eza --version
bat --version || batcat --version
zoxide add "$HOME"
zoxide query "$(basename "$HOME")"
```
