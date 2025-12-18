# AGENTS.md - AI Assistant Guide

> **Guide for AI assistants working with this Chezmoi dotfiles repository**

## Repository Overview

Chezmoi-managed dotfiles for David Harris. Modern, Catppuccin-themed, with Zsh primary and Fish secondary shells.

## Architecture

### Core Stack
- **Chezmoi**: Dotfile management with templating
- **Zsh + Zephyr**: Primary shell framework
- **Fish + Fisher**: Alternative shell
- **Neovim + LazyVim**: Editor
- **1Password CLI**: Secret management
- **Mise**: Tool version management
- **Homebrew**: Package management

### Directory Structure
```
chezmoi.toml.tmpl           # Chezmoi config (minimal)
.chezmoidata/
  data.yaml                 # Personal data (name, email, tools)
  packages.yaml             # Homebrew packages
.chezmoiignore              # Ignored files
bin/                        # Scripts (executable_*)
dot_config/
  fish/                     # Fish shell config
  zsh/                      # Zsh shell config
  git/config.tmpl           # Git configuration
  nvim/                     # Neovim (LazyVim)
  starship.toml             # Prompt config
  ghostty/config            # Terminal config
  brew/Brewfile.tmpl        # Homebrew bundle
```

## Template Variables

Available in `.chezmoidata/data.yaml`:
- `{{ .name }}` - Full name
- `{{ .email }}` - Email
- `{{ .github.username }}` - GitHub username
- `{{ .tools.editor }}` - Editor (nvim)
- `{{ .colorscheme }}` - Theme (catppuccin_macchiato)

Chezmoi built-ins:
- `{{ .chezmoi.hostname }}` - Machine hostname
- `{{ .chezmoi.os }}` - Operating system
- `{{ .chezmoi.arch }}` - Architecture

## Key Configuration Files

### Zsh (Primary)
- `dot_config/zsh/dot_zshrc` - Main config with Antidote plugin loading
- `dot_config/zsh/dot_zshenv` - Environment, PATH, XDG dirs
- `dot_config/zsh/dot_zaliases` - Aliases and modern tool replacements
- `dot_config/zsh/dot_zplugins` - Antidote plugin list
- `dot_config/zsh/conf.d/env.zsh` - Additional environment settings
- `dot_config/zsh/functions/` - Autoloaded functions

### Fish (Secondary)
- `dot_config/fish/config.fish` - Main config (runs after conf.d)
- `dot_config/fish/conf.d/__init__.fish` - XDG, PATH, Fisher init
- `dot_config/fish/conf.d/env.fish` - Environment variables
- `dot_config/fish/conf.d/abbr.fish` - Abbreviations
- `dot_config/fish/conf.d/tools.fish` - Tool integrations
- `dot_config/fish/functions/` - Custom functions
- `dot_config/fish/fish_plugins` - Fisher plugin list

### Git
- `dot_config/git/config.tmpl` - Main git config (templated)
- Uses Delta for diffs, difftastic for semantic diffs
- SSH signing via 1Password

## Packages

Defined in `.chezmoidata/packages.yaml`, rendered to `dot_config/brew/Brewfile.tmpl`.

Key packages: `bat`, `eza`, `fd`, `fzf`, `ripgrep`, `zoxide`, `starship`, `neovim`, `delta`, `difftastic`

## Common Operations

```bash
chezmoi apply        # Apply changes
chezmoi diff         # Preview changes
chezmoi edit FILE    # Edit managed file
chezmoi add FILE     # Add new file
chezmoi data         # View template data
```

## File Naming Conventions

- `dot_*` → Files starting with `.`
- `private_*` → Files with restricted permissions
- `executable_*` → Executable scripts
- `*.tmpl` → Template files
- `empty_*` → Empty placeholder files

## Design Principles

- **Theme**: Catppuccin Macchiato everywhere
- **Modern tools**: `eza`>`ls`, `bat`>`cat`, `fd`>`find`, `rg`>`grep`
- **Secrets**: 1Password CLI for all secrets
- **Performance**: Lazy loading, cached inits

## Debugging

```bash
chezmoi status                    # Check status
chezmoi data                      # View template data
chezmoi cat ~/.zshrc              # Preview rendered file
time zsh -i -c exit               # Profile zsh startup
time fish -c exit                 # Profile fish startup
```

## Credits

- [mattmc3/zephyr](https://github.com/mattmc3/zephyr) - Zsh framework
- [mattmc3/fishconf](https://github.com/mattmc3/fishconf) - Fish config patterns
- [LazyVim](https://lazyvim.github.io/) - Neovim config
- [Catppuccin](https://github.com/catppuccin) - Color scheme
