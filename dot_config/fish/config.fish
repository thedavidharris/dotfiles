# =============================================================================
# FISH SHELL CONFIGURATION
# Modern, fast, and organized Fish setup using Fish best practices
# =============================================================================

# =============================================================================
# ENVIRONMENT SETUP
# =============================================================================

# Set environment variables using Fish syntax
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# Create XDG directories
mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME

# Homebrew configuration
if test (uname -m) = "arm64"
    set -gx BREW_PREFIX /opt/homebrew
else
    set -gx BREW_PREFIX /usr/local
end

# Android SDK
set -gx ANDROID_HOME $HOME/Library/Android/sdk

# Editor and Visual
set -gx EDITOR nvim
set -gx VISUAL code

# Language and Locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Browser (macOS)
if test (uname) = "Darwin"
    set -gx BROWSER open
end

# Tool-specific environment variables
set -gx PYTHONIOENCODING UTF-8
set -gx GRADLE_USER_HOME $XDG_CONFIG_HOME/gradle
set -gx CLICOLOR 1
set -gx LESS "ij.5KMRX"
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
set -gx MANPATH ""
set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# =============================================================================
# PATH CONFIGURATION (Fish uses fish_add_path)
# =============================================================================

# Add directories to PATH using fish_add_path (Fish 3.3+)
# fish_add_path automatically prevents duplicates and only adds if paths exist
fish_add_path $HOME/bin $HOME/sbin
fish_add_path $HOME/.local/bin $HOME/.local/sbin
fish_add_path $HOME/.cargo/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path $BREW_PREFIX/bin $BREW_PREFIX/sbin
fish_add_path /usr/local/bin /usr/local/sbin
fish_add_path /bin

# =============================================================================
# INTERACTIVE SHELL CONFIGURATION
# =============================================================================

if status is-interactive
    # =============================================================================
    # CATPPUCCIN THEME COLORS
    # =============================================================================

    set -l catppuccin_macchiato_rosewater "f4dbd6"
    set -l catppuccin_macchiato_flamingo "f0c6c6"
    set -l catppuccin_macchiato_pink "f5bde6"

    # =============================================================================
    # TOOL INITIALIZATION
    # =============================================================================



    # Enable starship prompt
    if command -v starship > /dev/null
        starship init fish | source
    end

    # Enable zoxide for directory navigation
    if command -v zoxide > /dev/null
        zoxide init fish | source
    end

    # =============================================================================
    # KEY BINDINGS
    # =============================================================================

    # Fish-style history search (built-in, no plugins needed)
    # Up/Down arrows already work for history search in Fish

    # Additional useful bindings
    bind \cr history-search-backward  # Ctrl-R: reverse search
    bind \cs history-search-forward   # Ctrl-S: forward search

    # =============================================================================
    # FZF CONFIGURATION
    # =============================================================================

    # FZF key bindings and completion (if fzf is available)
    if command -v fzf > /dev/null
        # Source fzf key bindings and completion
        fzf --fish | source

        # Set FZF colors to match Catppuccin Macchiato
        set -gx FZF_DEFAULT_OPTS "--color=fg:#cad3f5,bg:#24273a,hl:#8aadf4,fg+:#cad3f5,bg+:#363a4f,hl+:#8aadf4,pointer:#f5bde6,marker:#f5bde6,spinner:#8aadf4,header:#8aadf4"
    end

    # =============================================================================
    # LS_COLORS CONFIGURATION
    # =============================================================================

    # Use vivid for LS_COLORS (same as Zsh)
    if command -v vivid > /dev/null
        set -gx LS_COLORS (vivid generate catppuccin-macchiato)
    end
end
