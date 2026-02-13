# AGENTS.md - Repo AI Guide

Guide for AI assistants working in this chezmoi source repository.

## Scope

- This root `AGENTS.md` is repo-local guidance only.
- It is intentionally ignored by `.chezmoiignore` and is not synced to `$HOME`.
- Home-synced agent guides:
  - `dot_agents/AGENTS.md` -> `~/.agents/AGENTS.md`

## Repository Overview

Chezmoi-managed dotfiles for David Harris. This repo is fish-first, with zsh as
secondary compatibility shell.

## Core Stack

- Chezmoi for dotfile management and templates
- Fish + Fisher (primary shell setup)
- Zsh + Zephyr (secondary shell setup)
- Neovim + LazyVim
- Mise for tool versions and env activation
- 1Password CLI/SSH agent for secrets and signing
- Homebrew managed via `packages.yaml`

## Directory Structure

<!-- GENERATED:agents-structure START -->
```text
.
|-- .chezmoidata/
|-- bin/
|-- docs/
|-- dot_agents/
|-- dot_config/
|   |-- agents/
|   |-- bash/
|   |-- bat/
|   |-- brew/
|   |-- delta/
|   |-- eza/
|   |-- fish/
|   |-- fnox/
|   |-- ghostty/
|   |-- git/
|   |-- mise/
|   |-- nvim/
|   |-- private_1Password/
|   |-- ripgrep/
|   |-- shell/
|   |-- starship.toml
|   |-- zsh/
|-- README.md
|-- AGENTS.md
```
<!-- GENERATED:agents-structure END -->

## Template Variables

Primary data source: `.chezmoidata/data.yaml`.

- `name`, `email`, `github.username`
- `tools.editor`, `tools.terminal`, `tools.shell`
- `colorscheme`

Chezmoi built-ins often used in templates:

- `.chezmoi.hostname`
- `.chezmoi.os`
- `.chezmoi.arch`

## Key Config Files

### Fish (Primary)

- `dot_config/fish/config.fish`
- `dot_config/fish/conf.d/__init__.fish`
- `dot_config/fish/conf.d/env.fish`
- `dot_config/fish/conf.d/tools.fish`
- `dot_config/fish/fish_plugins`

### Zsh (Secondary)

- `dot_config/zsh/dot_zshenv`
- `dot_config/zsh/dot_zshrc`
- `dot_config/zsh/conf.d/env.zsh`

### Other

- `dot_config/mise/config.toml` (runtime/env config)
- `dot_config/git/config.tmpl` (git behavior + signing)
- `dot_config/brew/Brewfile.tmpl` (rendered from package data)
- `docs/PRIVACY.md` (privacy/work-config policy)

## Package Source of Truth

`packages.yaml` is the canonical package list.

<!-- GENERATED:agents-packages START -->
- Source of truth: `.chezmoidata/packages.yaml`
- Homebrew formulas: `64`
- Homebrew casks: `15`
- Homebrew taps: `0`
- Key tools: `fish`, `mise`, `chezmoi`, `neovim`, `ripgrep`, `fd`, `eza`, `starship`
<!-- GENERATED:agents-packages END -->

## Common Operations

```bash
chezmoi diff
chezmoi apply
chezmoi status
chezmoi data
docs-gen
docs-lint
```

## Working Rules

- Prefer fish paths/examples unless zsh-specific behavior is required.
- Keep company/internal values out of tracked files; use env-backed values.
- Keep README/AGENTS generated sections current via `docs-gen`.
- Do not edit `.env` in automation; treat as local-only.
