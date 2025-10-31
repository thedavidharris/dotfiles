# David's Dotfiles

> **Managed with [Chezmoi](https://www.chezmoi.io/)**

Personal dotfiles featuring Catppuccin color scheme, Zsh with Zephyr framework, Neovim with LazyVim, and 1Password integration.

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
- **Fish** shell with Fisher plugin manager
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

## 🙏 Credits & Sources

This configuration draws inspiration and uses code from:

- **[mattmc3/zephyr](https://github.com/mattmc3/zephyr)** - Zsh framework and configuration inspiration
- **[mattmc3/fishconf](https://github.com/mattmc3/fishconf)** - Fish shell configuration inspiration
- **[LazyVim/LazyVim](https://lazyvim.github.io/)** - Neovim configuration framework
- **[jorgebucaran/fisher](https://github.com/jorgebucaran/fisher)** - Fish plugin manager
- **[Catppuccin](https://github.com/catppuccin)** - Color scheme
- **Zsh community plugins**:
  - [zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions)
  - [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
  - [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- **Fish plugins**:
  - [jethrokuan/z](https://github.com/jethrokuan/z) - Directory jumping
  - [mattmc3/macos.fish](https://github.com/mattmc3/macos.fish) - macOS utilities
  - [mattmc3/up.fish](https://github.com/mattmc3/up.fish) - Directory navigation
  - [jorgebucaran/autopair.fish](https://github.com/jorgebucaran/autopair.fish) - Auto-pairing
  - [franciscolourenco/done](https://github.com/franciscolourenco/done) - Notifications
- **[Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab)** - Zsh completion with fzf
- **[romkatv/zsh-bench](https://github.com/romkatv/zsh-bench)** - Zsh benchmarking tool
- **[mattmc3/zsh-safe-rm](https://github.com/mattmc3/zsh-safe-rm)** - Safe rm wrapper
