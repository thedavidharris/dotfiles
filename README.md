# David's Dotfiles

Fish, Neovim, and developer tools for macOS and Ubuntu on WSL 2.
Chezmoi manages files, Homebrew installs tools, and mise provides Node.

## Install

First install and unlock the 1Password desktop app, enable its SSH agent and
CLI integration, and add your GitHub SSH key. Then run this in macOS Terminal
or inside Ubuntu on WSL.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/thedavidharris/dotfiles/main/install.sh)"
```

The installer handles Homebrew and its prerequisites, asks for your machine
profile, backs up existing managed files, and applies the setup. On a fresh Mac,
finish any Command Line Tools installer if prompted and rerun the command.
Backups are saved under `~/.local/state/dotfiles/backups`.

Private agent configs and macOS system preferences are optional. The installer
finishes the core before fetching private agents. It installs the Mac CLI
with Homebrew and the Windows CLI with WinGet from WSL. Approve any 1Password authentication prompts. A failed step
can be retried by running the same command again.

For an existing checkout, run `bash install.sh`. See [WSL setup](docs/WSL.md)
for terminal and Windows settings.

## Everyday use

```fish
chezmoi diff          # Preview changes
chezmoi apply         # Apply files and install missing packages
chezmoi update        # Pull and apply repository updates
```

Edit [the Brewfile](dot_config/brew/Brewfile) directly to change packages.
Use `mise use` in individual projects for additional language runtimes.
Machine settings live under `[data]` in `~/.config/chezmoi/chezmoi.toml`.
Use `chezmoi init --prompt` to change saved answers. `keepLocal` lists
home-relative paths to leave under local control. Fish overrides go in
`~/.config/fish/local/config.fish`.

Bootstrap checks use temporary homes and mocked installers. Run
`python3 scripts/check-bootstrap.py` with Python 3.11+, chezmoi, Fish, Ruby,
and ShellCheck installed.
