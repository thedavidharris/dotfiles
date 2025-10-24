# David's Dotfiles

> **Managed with [Chezmoi](https://www.chezmoi.io/)**

Modern dotfiles featuring Catppuccin color scheme, Zsh with Zephyr framework, Neovim with LazyVim, and 1Password integration.

## 🚀 Quick Start

```bash
# Install Chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# Initialize dotfiles
chezmoi init --apply https://github.com/thedavidharris/dotfiles.git
exec zsh  # Restart shell
```

## 🎨 Features

- **Zsh** with [Zephyr](https://github.com/mattmc3/zephyr) framework
- **Neovim** with [LazyVim](https://lazyvim.github.io/) configuration
- **Starship** prompt with Catppuccin Macchiato theme
- **Mise** for tool version management
- **1Password CLI** integration for secrets
- **Delta** for beautiful git diffs
- **Hammerspoon** for macOS automation

## 🔧 Usage

```bash
# Apply dotfiles changes
chezmoi apply

# Edit configurations
chezmoi edit ~/.zshrc
```

## 🎯 Customization

- **Aliases**: `dot_config/zsh/dot_zaliases`
- **Environment**: `dot_config/zsh/dot_zshenv`
- **Colors**: Catppuccin theme across all tools
- **Packages**: Defined in `.chezmoidata/packages.yaml`

## 🐛 Troubleshooting

- **Shell issues**: Run `exec zsh` to reload
- **Plugin problems**: Check `~/.zsh_plugins.zsh` exists
- **Git signing**: Ensure 1Password SSH agent is running
