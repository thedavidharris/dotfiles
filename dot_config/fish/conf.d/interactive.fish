#
# interactive
#

# Disable new user greeting.
set fish_greeting

# Fish cursor shape
fish_set_cursor bar

# =============================================================================
# Tool Initialization (with caching for performance)
# =============================================================================

# Initialize direnv
if type -q direnv
    direnv hook fish | source
end

# Initialize fuzzy finder
if type -q fzf
    if not test -r $__fish_cache_dir/fzf_init.fish
        fzf --fish >$__fish_cache_dir/fzf_init.fish
    end
    source $__fish_cache_dir/fzf_init.fish

    # Set FZF colors to match Catppuccin Macchiato
    set -gx FZF_DEFAULT_OPTS "--color=fg:#cad3f5,bg:#24273a,hl:#8aadf4,fg+:#cad3f5,bg+:#363a4f,hl+:#8aadf4,pointer:#f5bde6,marker:#f5bde6,spinner:#8aadf4,header:#8aadf4"
end

# Initialize zoxide for fast jumping with 'z'
if type -q zoxide
    if not test -r $__fish_cache_dir/zoxide_init.fish
        zoxide init fish >$__fish_cache_dir/zoxide_init.fish
    end
    source $__fish_cache_dir/zoxide_init.fish
end

# =============================================================================
# Prompt Initialization
# =============================================================================

# Initialize starship
if type -q starship
    if not test -r $__fish_cache_dir/starship_init.fish
        starship init fish --print-full-init >$__fish_cache_dir/starship_init.fish
    end
    source $__fish_cache_dir/starship_init.fish
end

# =============================================================================
# LS_COLORS Configuration
# =============================================================================

# Use vivid for LS_COLORS (matches terminal theme)
if command -v vivid >/dev/null
    set -gx LS_COLORS (vivid generate catppuccin-macchiato)
end
