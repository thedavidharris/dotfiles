# AGENTS.md - Repo AI Guide

Guide for AI assistants working in this chezmoi source repository.

## Scope

- This root `AGENTS.md` is repo-local guidance only.
- It is intentionally ignored by `.chezmoiignore` and is not synced to `$HOME`.
- Agent config is not stored here. `~/.agents` is cloned from a private repo
  (chezmoi external) and holds `AGENTS.md`, personal skills, and `agents.base.toml`.
- On work machines (`isWork`), a separate private work repo adds `agents.work.toml`.
- A chezmoi script composes `~/.agents/agents.toml` from base (+ work) and runs
  `dotagents install`. Treat `agents.toml` as generated; never run `dotagents add` on it.

## Repository Overview

Chezmoi-managed dotfiles for David Harris. This repo is fish-first; system zsh
is used for bootstrapping, but no zsh dotfiles are managed.

## Directory Structure

<!-- GENERATED:agents-structure START -->
```text
.
|-- .chezmoidata/
|-- bin/
|-- docs/
|-- dot_config/
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
|   |-- starship.toml
|   |-- uv/
|-- README.md
|-- AGENTS.md
```
<!-- GENERATED:agents-structure END -->

## Template Data

`.chezmoidata/data.yaml` (name, personalEmail, tools, colorscheme) plus machine
data in `~/.config/chezmoi/chezmoi.toml`. Init prompts for `isWork`, `workEmail`
(work only), and `configureMacOS`; it selects the active `email` and preserves
local `[data]` overrides. Use `.email` in shared templates and `WORK_EMAIL` in
environment-backed work integrations. Never put the actual work address here.

## Package Source of Truth

`packages.yaml` is the canonical package list.

<!-- GENERATED:agents-packages START -->
- Source of truth: `.chezmoidata/packages.yaml`
- Homebrew formulas: `88`
- Homebrew casks: `18`
- Homebrew taps: `0`
- Key tools: `fish`, `mise`, `chezmoi`, `neovim`, `ripgrep`, `fd`, `eza`, `starship`
<!-- GENERATED:agents-packages END -->

## Common Operations

```bash
chezmoi diff
chezmoi apply
chezmoi status
chezmoi data
python3 scripts/docs-gen.py
python3 scripts/check-bootstrap.py
```

## Working Rules

- Prefer fish paths/examples unless zsh-specific behavior is required.
- Keep company/internal values out of tracked files; use env-backed values.
- Keep README/AGENTS generated sections current via `python3 scripts/docs-gen.py`.
- Do not edit `.env` in automation; treat as local-only.
