# Fish Shell Configuration
# Set theme to match your Catppuccin setup
if status is-interactive
    set -gx EDITOR nvim
    set -gx VISUAL code

    # Catppuccin theme colors
    set -l catppuccin_macchiato_rosewater "f4dbd6"
    set -l catppuccin_macchiato_flamingo "f0c6c6"
    set -l catppuccin_macchiato_pink "f5bde6"

    # Aliases that match your zsh setup
    alias .. "cd .."
    alias ... "cd ../.."
    alias grep "grep --color=auto"

    # Enable mise for version management
    if command -v mise > /dev/null
        mise activate fish | source
    end

    # Enable starship prompt
    if command -v starship > /dev/null
        starship init fish | source
    end
end
