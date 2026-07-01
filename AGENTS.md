# Repository Guidelines

## Project Overview

Chezmoi-managed terminal/dotfiles setup for macOS, Ubuntu, and Raspberry Pi OS. The repository provisions and configures zsh, Starship, tmux, Ghostty on macOS, modern CLI tools (`eza`, `bat`, `ripgrep`, `fd`, `fzf`, `zoxide`, `delta`, `bottom`, `dust`, `procs`), and a global `just` file.

This is not an application repo: there is no `src/`, package build, unit-test suite, or coverage gate. Treat changes as shell/dotfile/provisioning work and validate rendered home-directory output.

## Architecture & Data Flow

- Chezmoi is the organizing layer. Source filenames map to home files: `dot_zshrc` -> `~/.zshrc`, `dot_config/starship.toml` -> `~/.config/starship.toml`, `private_dot_env.tmpl` -> private `~/.env`.
- Bootstrap flow:
  1. Install/fetch Chezmoi.
  2. Run `chezmoi init --apply https://github.com/eduzen/dotfiles.git`.
  3. Chezmoi renders templates and, unless excluded, can run `run_once_*` installer scripts.
  4. zsh startup reads generated env/aliases and initializes optional tools.
- Shell startup split:
  - `dot_zprofile`: login-shell PATH, Homebrew discovery, optional pyenv path init.
  - `dot_zshrc`: interactive shell setup; sources `~/.env`, `~/.aliases`, `~/.aliases_private`, `~/.extras`, Cargo/fzf/GCloud snippets, then initializes completions, pyenv, zoxide, and Starship when available.
- OS-specific provisioning:
  - `run_once_install-packages-darwin.sh.tmpl`: Darwin-only, Homebrew required, installs CLI tools plus Ghostty/font casks.
  - `run_once_install-packages-linux.sh.tmpl`: Linux-only, apt-based Ubuntu/Raspberry Pi OS only, optional Rust/cargo fallback when `INSTALL_RUSTUP=1`.
- Platform-specific config uses Chezmoi Go templates and `.chezmoi.os`; keep Darwin/Linux guards explicit.

## Key Directories

- `.`: Chezmoi source root for dotfiles, templates, installer scripts, and repository metadata.
- `dot_config/`: Files rendered under `~/.config/`; currently Starship and Darwin-gated Ghostty config.
- `dot_config/ghostty/`: macOS-only Ghostty template.
- `.github/workflows/`: CI validation workflow.
- `.github/`: Dependabot and workflow configuration.

There are no tracked `src/`, `tests/`, `scripts/`, or docs directories. `.gitignore` is deny-by-default; add explicit allowlist entries for any new tracked file.

## Development Commands

Bootstrap from README:

```sh
# macOS
brew install chezmoi
chezmoi init --apply https://github.com/eduzen/dotfiles.git

# Ubuntu / Raspberry Pi OS
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/eduzen/dotfiles.git
```

Local development from a clone:

```sh
chezmoi --source "$PWD" diff --exclude=scripts
chezmoi --source "$PWD" apply
exec zsh
```

Safer validation commands:

```sh
pre-commit run --all-files
shellcheck --severity=error run_once_*.sh.tmpl
zsh -n dot_zprofile dot_zshrc dot_aliases dot_aliases_private.tmpl
```

CI-style Chezmoi render check without package installers:

```sh
tmp_home="$(mktemp -d)"
chezmoi --source "$PWD" --destination "$tmp_home" --dry-run --verbose apply --exclude=scripts
chezmoi --source "$PWD" --destination "$tmp_home" apply --exclude=scripts --force
chezmoi --source "$PWD" --destination "$tmp_home" verify --exclude=scripts
```

Manual smoke checks after applying locally:

```sh
tmux
starship explain
eza --version
bat --version || batcat --version
zoxide add "$HOME"
zoxide query "$(basename "$HOME")"
```

Global `just` recipes live in `dot_global.justfile` and render as `~/.global.justfile`:

```sh
just clean-python
just clean-docker-containers
just clean-docker-exited-containers
```

Do not run Docker cleanup recipes as routine verification; they stop/remove containers broadly.

## Code Conventions & Common Patterns

- Shell files use Bash-compatible style even for zsh startup files: `# shellcheck shell=bash`, `[[ ... ]]`, quoted variables, small helper functions.
- Installer scripts must keep `#!/usr/bin/env bash` and `set -euo pipefail`.
- Guard optional tooling with `command -v`, optional files with `[[ -f ... ]]`, and optional directories with `[[ -d ... ]]`; shell startup should not fail when a tool is absent.
- Preserve idempotent PATH handling via `_path_prepend`; avoid raw PATH prepends that duplicate entries or fail on missing directories.
- Source order in `dot_zshrc` matters: env first, public aliases, private aliases, extras, tool snippets, then prompt/navigation integrations.
- Clean up temporary shell helpers with `unset -f` at the end of startup files.
- Personal/operational aliases are comma-prefixed (examples: `,j`, `,cleanpython`, `,mountdownloads`) to avoid command collisions. Broad aliases are rare (`j`, `ll`, `cat`, `grep`, `fd`).
- Secrets must not be committed. Use `private_dot_env.tmpl` defaults and environment variables such as `SAMBAPASS`; keep literal secret values only in the generated local `~/.env` or ambient environment.
- Chezmoi templates use Go-template syntax such as `{{- if eq .chezmoi.os "darwin" }}`; preserve whitespace-trimming and OS guards.
- Formatting: LF endings, final newline, trim trailing whitespace, 2-space default indentation; Python uses 4 spaces and max line length 88 per `.editorconfig`.

## Important Files

- `README.md`: Purpose, bootstrap commands, local Chezmoi workflow, private-file guidance, smoke tests.
- `.chezmoiignore.tmpl`: Prevents repository-only files from rendering into `$HOME`; excludes Ghostty config on non-Darwin hosts.
- `dot_zprofile`: Login shell PATH/Homebrew/pyenv setup.
- `dot_zshrc`: Interactive zsh setup, optional source files, completions, pyenv, zoxide, Starship.
- `dot_aliases`: Public aliases and compatibility fallbacks for `eza`, `batcat`, `rg`, `fdfind`.
- `dot_aliases_private.tmpl`: Private/local aliases; consumes env vars and host-specific paths.
- `private_dot_env.tmpl`: Private `~/.env` template with empty/env-default host values and Python/Docker defaults.
- `dot_global.justfile`: Global cleanup recipes rendered to `~/.global.justfile`.
- `dot_tmux.conf`: tmux preferences, including `C-a` prefix and vi mode keys.
- `dot_gitconfig`: Global Git identity/defaults; avoid casual behavior changes.
- `dot_config/starship.toml`: Prompt module order and symbols.
- `dot_config/ghostty/config.tmpl`: Darwin-only Ghostty font/theme/zsh integration.
- `run_once_install-packages-darwin.sh.tmpl`: Homebrew-based macOS installer.
- `run_once_install-packages-linux.sh.tmpl`: apt-based Linux installer with optional cargo fallback.
- `.pre-commit-config.yaml`: Hygiene hooks and ShellCheck.
- `.github/workflows/check.yml`: Canonical CI validation flow.
- `.github/dependabot.yml`: Daily updates for pip, GitHub Actions, and Docker ecosystem metadata.
- `.gitignore`: Allowlist-based; new tracked files need explicit unignore rules.

## Runtime/Tooling Preferences

- Primary runtime shell: zsh.
- Dotfile manager: Chezmoi.
- macOS package manager: Homebrew; Ghostty and JetBrains Mono Nerd Font installed as casks.
- Linux package manager: `apt-get`; supported targets are Ubuntu and Raspberry Pi OS. Non-apt distros are intentionally unsupported by the installer.
- Optional fallback: `INSTALL_RUSTUP=1` permits rustup/cargo installs for modern CLI tools when packages are unavailable.
- Python tooling in `requirements.txt` includes `pre-commit`, `black`, `flake8`, `isort`, `pylint`, `neovim`, and `pynvim`; CI does not currently run Black/Flake8/isort/Pylint directly.
- Prefer `chezmoi --source "$PWD" diff --exclude=scripts` before apply. Excluding scripts avoids package installation side effects.
- Avoid host-mutating commands unless explicitly requested: `chezmoi apply` without `--exclude=scripts`, installer templates, `sudo apt-get`, `brew install`, rustup/cargo fallback, and Docker cleanup recipes.

## Testing & QA

- There is no conventional unit-test framework or coverage target.
- Primary checks:
  - `pre-commit run --all-files`
  - `shellcheck --severity=error run_once_*.sh.tmpl`
  - `zsh -n dot_zprofile dot_zshrc dot_aliases dot_aliases_private.tmpl`
  - Chezmoi dry-run/apply/verify into a temporary destination with `--exclude=scripts`
  - Generated-home zsh startup smoke from CI: source `.zprofile` and `.zshrc`, then check aliases such as `j` and `ll`.
- GitHub Actions `Check` runs on push/PR to `main` and manual dispatch. It installs `shellcheck`, `zsh`, and Chezmoi, runs pre-commit, ShellCheck, zsh parse checks, Chezmoi render/apply/verify, validates generated `.env` mode `600`, and smoke-sources generated zsh files.
- Pre-commit hooks include whitespace/EOF/line-ending checks, YAML/JSON/TOML syntax checks, `requirements-txt-fixer`, private-key detection, executable shebang checks, merge-conflict checks, and ShellCheck at error severity.
- For shell or template changes, prefer targeted CI-equivalent commands over broad host apply. For installer changes, use ShellCheck and review OS guards before any real package-manager run.
