# Fish Tool Configurations
# Tool-specific settings and integrations

# =============================================================================
# 1PASSWORD CONFIGURATION
# =============================================================================

# 1Password CLI integration
alias gh="op plugin run -- gh"

# =============================================================================
# FZF CONFIGURATION
# =============================================================================

# FZF colors matching Catppuccin Macchiato (if not already set in config.fish)
if command -v fzf > /dev/null
    set -gx FZF_DEFAULT_OPTS "--color=fg:#cad3f5,bg:#24273a,hl:#8aadf4,fg+:#cad3f5,bg+:#363a4f,hl+:#8aadf4,pointer:#f5bde6,marker:#f5bde6,spinner:#8aadf4,header:#8aadf4"
end

# =============================================================================
# ADDITIONAL TOOL CONFIGURATIONS
# =============================================================================

# Enable colors for grep (if not using rg)
if not command -v rg > /dev/null
    alias grep "grep --color=auto"
end

# Tree with colors (if tree is installed and not using eza)
if command -v tree > /dev/null && not command -v eza > /dev/null
    alias tree "tree -C"
end
