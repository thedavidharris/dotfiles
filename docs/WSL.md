# WSL2 Setup

This repository supports WSL2 with a hybrid package strategy:

- apt for base Linux dependencies.
- Homebrew (Linuxbrew) for shared CLI tools rendered from `packages.yaml`.
- mise for language/runtime versions.

## 1) Bootstrap apt dependencies

```bash
sudo apt update
sudo apt install -y \
  build-essential curl file git ca-certificates procps xz-utils unzip
```

## 2) Optional: install Homebrew on WSL

If you want package parity with macOS for CLI tools, install Linuxbrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then initialize Homebrew in your current shell:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

## 3) Install chezmoi and apply dotfiles

If Homebrew is installed:

```bash
brew install chezmoi
chezmoi init --apply https://github.com/thedavidharris/dotfiles.git
```

If Homebrew is not installed:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
~/.local/bin/chezmoi init --apply https://github.com/thedavidharris/dotfiles.git
```

## 4) Machine-specific overrides

Add local machine overrides in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
profile = "wsl"

# Override if your environment uses non-default 1Password paths.
ssh_signing_program = "/opt/1Password/op-ssh-sign"
ssh_agent_sock = "~/.1password/agent.sock"
```

The templates default to Linux/WSL-safe paths and allow these per-machine
overrides without changing tracked source files.

## 5) SSH signing requirements

This repo requires commit signing on both macOS and Linux/WSL.

Verify the effective configuration:

```bash
git config --get commit.gpgsign
git config --get gpg.format
git config --get gpg.ssh.program
git config --get user.signingkey
```

Expected values include:

- `commit.gpgsign = true`
- `gpg.format = ssh`
- `gpg.ssh.program` points to `op-ssh-sign` (or your machine override)

## 6) Chezmoi machine-difference patterns used here

This repo applies chezmoi's machine-difference guidance:

- Use template conditionals by OS for config that changes by platform.
- Use local machine data (`~/.config/chezmoi/chezmoi.toml`) for path overrides.
- Use `.chezmoiignore` and shared templates in `.chezmoitemplates` only when
  the same content must live at different target paths.

Reference:

- https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/#handle-different-file-locations-on-different-systems-with-the-same-contents
