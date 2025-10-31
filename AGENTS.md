# AGENTS.md - AI Assistant Guide

> **Guide for AI assistants working with this Chezmoi dotfiles repository**

## Repository Overview

This is a **Chezmoi-managed dotfiles repository** for David Harris. The configuration is modern, comprehensive, and uses advanced templating features.

## 🏗️ Architecture

### **Core Technologies**
- **Chezmoi**: Dotfile manager with templating
- **Zsh + Zephyr**: Modern shell framework (primary)
- **Fish**: Alternative shell with shared environment
- **Neovim + LazyVim**: Editor configuration
- **1Password CLI**: Secret management
- **Mise**: Tool version management
- **Homebrew**: Package management

### **Key Files Structure**
```
chezmoi.toml.tmpl          # Main Chezmoi configuration (TEMPLATED)
.chezmoidata/packages.yaml # Package definitions
.chezmoiignore             # Files to ignore
bin/                       # Executable scripts
dot_config/                # All configuration files
```

## 🔧 Chezmoi Configuration

### **Template Data Structure**
The `chezmoi.toml.tmpl` contains:
```toml
[data]
    name = "David Harris"
    email = "davidaharris@outlook.com"
    github = { username = "thedavidharris" }
    brew = { prefix = "{{ if stat \"/opt/homebrew\" }}/opt/homebrew{{ else }}/usr/local{{ end }}" }
```

### **Available Template Variables**
- `{{ .name }}` - User's full name
- `{{ .email }}` - User's email
- `{{ .github.username }}` - GitHub username
- `{{ .chezmoi.hostname }}` - Machine hostname
- `{{ .chezmoi.os }}` - Operating system
- `{{ .chezmoi.arch }}` - Architecture

### **1Password Integration**
```bash
# SSH key from 1Password
{{ onepasswordRead "op://Private/github_personal/public key" }}

# Other secrets
{{ onepasswordRead "op://Private/aws/access_key" }}
```

## 📁 Key Configuration Files

### **Shell Configuration**
- `dot_config/shell/env.sh` - Shared POSIX environment (used by both shells)
- `dot_config/zsh/dot_zshrc` - Main Zsh config with Zephyr
- `dot_config/zsh/dot_zshenv` - Zsh environment (sources shared env)
- `dot_config/zsh/dot_zaliases` - Zsh command aliases
- `dot_config/zsh/dot_zplugins` - Zsh plugin definitions
- `dot_config/fish/config.fish` - Main Fish configuration
- `dot_config/fish/fish_plugins` - Fish plugin definitions
- `dot_config/fish/conf.d/` - Fish modular configuration
- `dot_config/fish/functions/` - Fish-specific functions

### **Git Configuration**
- `dot_config/git/config.personal.tmpl` - Personal git config (TEMPLATED)
- `dot_config/git/themes.gitconfig` - Delta themes
- `dot_gitconfig.tmpl` - Main git config (TEMPLATED)

### **Development Tools**
- `dot_config/nvim/init.lua` - Neovim bootstrap
- `dot_config/mise/config.toml` - Tool versions
- `dot_config/brew/Brewfile.tmpl` - Homebrew packages (TEMPLATED)

## 🎨 Design Philosophy

### **Color Scheme**
- **Primary**: Catppuccin Macchiato (dark theme)
- **Consistent**: Applied across all tools (Starship, Delta, Bat, Neovim)
- **Modern**: Dark mode optimized

### **Tool Selection**
- **Modern alternatives**: `eza` over `ls`, `bat` over `cat`, `fd` over `find`
- **Performance focused**: Fast shell startup, async operations
- **Developer friendly**: Comprehensive git aliases, helpful shortcuts

## 🔐 Security Model

### **Secret Management**
- **1Password CLI**: All secrets stored in 1Password
- **SSH Keys**: Managed through 1Password SSH agent
- **Encryption**: Age encryption for sensitive files
- **Git Signing**: GPG signing with SSH keys

### **Ignored Files** (`.chezmoiignore`)
```
*.key, *.pem, *.p12          # Private keys
.env.local                   # Local environment files
.aws/credentials             # AWS credentials
.ssh/id_*                    # SSH private keys
```

## 🛠️ Common Operations

### **Adding New Configurations**
```bash
# Add a new config file
chezmoi add ~/.config/newtool/config

# Add as template (for machine-specific configs)
chezmoi add --template ~/.config/newtool/config

# Add with encryption (for sensitive files)
chezmoi add --encrypt ~/.ssh/config
```

### **Modifying Existing Configs**
```bash
# Edit a managed file
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Check status
chezmoi status
```

### **Template Development**
```bash
# View available template data
chezmoi data

# Test template rendering
chezmoi execute-template '{{ .chezmoi.hostname }}'

# Preview template output
chezmoi cat ~/.zshrc
```

## 📋 Package Management

### **Homebrew Packages**
Defined in `dot_config/brew/Brewfile.tmpl` using templating:
```bash
{{ range .packages.darwin.brews -}}
brew {{ . | quote }}
{{ end -}}
```

### **Package Definitions**
All packages defined in `.chezmoidata/packages.yaml`:
- **Core tools**: git, gh, mise, chezmoi
- **CLI utilities**: bat, fzf, jq, tree, zoxide
- **Development**: neovim, difftastic, starship
- **Shells**: zsh, fish (both supported)
- **System**: 1password, ghostty, hammerspoon

## 🚀 Automation Scripts

### **Key Scripts in `bin/`**
- `executable_chezmoi-apply` - Apply both personal and work configs
- `executable_update-everything` - Update all packages and plugins
- `executable_cleanup-system` - System cleanup tasks

### **Update Workflow**
```bash
# The update-everything script handles:
# 1. Neovim plugins (local only)
# 2. Homebrew packages
# 3. Mise tools
# 4. Chezmoi dotfiles sync
```

## 🎯 Machine-Specific Features

### **Hostname Detection**
```bash
# In templates, detect specific machines
{{- if eq .chezmoi.hostname "A18974" }}
# Machine-specific configuration
{{- end }}
```

### **OS Detection**
```bash
# Different configs for different OS
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific settings
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific settings
{{- end }}
```

## 🔍 Debugging & Troubleshooting

### **Common Issues**
1. **Template errors**: Check `chezmoi data` for available variables
2. **1Password issues**: Ensure `op` CLI is authenticated
3. **Shell problems**: Check if `~/.zsh_plugins.zsh` exists
4. **Git signing**: Verify 1Password SSH agent is running

### **Debug Commands**
```bash
# Check Chezmoi status
chezmoi status

# View template data
chezmoi data

# Test configuration
chezmoi diff

# Verbose apply
chezmoi apply -v

# Check specific file
chezmoi cat ~/.zshrc
```

## 📚 Key Dependencies

### **Required Tools**
- **Chezmoi**: Dotfile management
- **1Password CLI**: Secret management
- **Homebrew**: Package management
- **Mise**: Tool version management
- **Zsh**: Primary shell (with Zephyr framework)
- **Fish**: Alternative shell (optional, coexists with Zsh)

### **Shell Dependencies**
- **Zsh**: Primary shell
- **Antidote**: Plugin manager
- **Starship**: Prompt
- **Zoxide**: Directory navigation

## 🐟 Fish Shell Configuration

### **Fish Architecture**
The Fish configuration follows a modular approach with shared environment variables:

- **Shared Environment**: `dot_config/shell/env.sh` contains POSIX-compatible environment variables used by both Zsh and Fish
- **Fish-Specific**: `dot_config/fish/config.fish` contains Fish-specific syntax and configurations
- **Modular Config**: `dot_config/fish/conf.d/` contains modular configuration files loaded automatically
- **Functions**: `dot_config/fish/functions/` contains Fish-specific functions

### **Fish Plugin Management**
Uses Fisher plugin manager with minimal essential plugins:
- `jorgebucaran/fisher` - Plugin manager itself
- `mattmc3/macos.fish` - macOS-specific Fish functions
- `jethrokuan/z` - Directory jumping (zoxide integration)

### **Fish vs Zsh Differences**
- **Abbreviations**: Fish uses abbreviations instead of aliases (better UX)
- **Built-in Features**: Fish includes autosuggestions and syntax highlighting natively
- **PATH Management**: Fish uses `fish_user_paths` instead of PATH arrays
- **Functions**: Fish functions use different syntax but same functionality

### **Fish Configuration Files**
- `dot_config/fish/config.fish` - Main configuration
- `dot_config/fish/fish_plugins` - Plugin definitions
- `dot_config/fish/conf.d/00-env.fish` - Environment loader
- `dot_config/fish/conf.d/10-abbr.fish` - Abbreviations
- `dot_config/fish/conf.d/20-tools.fish` - Tool configurations
- `dot_config/fish/functions/` - Custom Fish functions

### **Fish Debugging Commands**
```bash
# Check Fish configuration
fish --config-dir

# Test Fish startup time
time fish -c exit

# Debug Fish functions
functions mkcd

# Check Fish abbreviations
abbr --list

# View Fish variables
set --show fish_user_paths
```

## 🎨 Customization Guidelines

### **Adding New Tools**
1. Add to `packages.yaml` for Homebrew installation
2. Create config template in `dot_config/`
3. Add shell aliases if needed
4. Update mise config for version management

### **Color Scheme Changes**
- **Starship**: `dot_config/starship.toml`
- **Delta**: `dot_config/delta/themes.gitconfig`
- **Bat**: `dot_config/bat/config`

### **Shell Customization**
- **Aliases**: `dot_config/zsh/dot_zaliases`
- **Functions**: `dot_config/zsh/functions/`
- **Environment**: `dot_config/zsh/dot_zshenv`

## ⚠️ Important Notes

### **Template Syntax**
- Uses Go template syntax: `{{ .variable }}`
- Conditionals: `{{- if eq .var "value" }}`
- Loops: `{{ range .items }}`
- Functions: `{{ .var | quote }}`

### **File Naming Conventions**
- `dot_*` - Files that start with dot in home directory
- `dot_config/*` - Files in `~/.config/`
- `executable_*` - Executable scripts in `bin/`
- `*.tmpl` - Template files

### **Security Considerations**
- Never commit secrets to version control
- Use 1Password for all sensitive data
- Encrypt files with `--encrypt` flag when needed
- Check `.chezmoiignore` for excluded files

## 🔄 Workflow Integration

### **Daily Usage**
```bash
# Apply changes
chezmoi apply

# Update everything
update-everything

# Edit configurations
chezmoi edit ~/.zshrc
```

### **Development**
```bash
# Add new files
chezmoi add ~/.config/newtool/config

# Commit changes
chezmoi commit -m "Add new configuration"

# Push to remote
chezmoi push
```

## 🙏 Credits & Sources

This configuration draws inspiration and uses code from the following sources:

### **Core Frameworks**
- **[mattmc3/zephyr](https://github.com/mattmc3/zephyr)** - Zsh framework and all Zephyr plugins
- **[mattmc3/fishconf](https://github.com/mattmc3/fishconf)** - Fish shell configuration structure and patterns
- **[LazyVim/LazyVim](https://lazyvim.github.io/)** - Neovim configuration framework
- **[folke/lazy.nvim](https://github.com/folke/lazy.nvim)** - Lazy plugin manager for Neovim

### **Shell Plugins & Tools**
- **[jorgebucaran/fisher](https://github.com/jorgebucaran/fisher)** - Fish plugin manager
- **[jorgebucaran/autopair.fish](https://github.com/jorgebucaran/autopair.fish)** - Auto-pairing brackets for Fish
- **[jethrokuan/z](https://github.com/jethrokuan/z)** - Directory jumping for Fish (zoxide integration)
- **[mattmc3/macos.fish](https://github.com/mattmc3/macos.fish)** - macOS-specific Fish functions
- **[mattmc3/up.fish](https://github.com/mattmc3/up.fish)** - Directory navigation for Fish
- **[mattmc3/zsh-safe-rm](https://github.com/mattmc3/zsh-safe-rm)** - Safe rm wrapper for Zsh

### **Zsh Community Plugins**
- **[zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions)** - Additional completions
- **[zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** - Command suggestions
- **[zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** - Syntax highlighting
- **[zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)** - History search

### **Fish Plugins**
- **[franciscolourenco/done](https://github.com/franciscolourenco/done)** - Notifications for long-running commands
- **[catppuccin/fish](https://github.com/catppuccin/fish)** - Catppuccin theme for Fish

### **Other Tools**
- **[Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab)** - Zsh completion with fzf
- **[romkatv/zsh-bench](https://github.com/romkatv/zsh-bench)** - Zsh benchmarking tool
- **[Catppuccin](https://github.com/catppuccin)** - Color scheme used across tools

### **Documentation & Inspiration**
- [Fish shell cookbook](https://github.com/jorgebucaran/fish-shell-cookbook) - Fish configuration patterns
- [Fish shell default config](https://github.com/fish-shell/fish-shell/blob/master/share/config.fish) - Reference implementation

---

**This guide should help AI assistants understand the structure, conventions, and best practices for working with this dotfiles repository.**
