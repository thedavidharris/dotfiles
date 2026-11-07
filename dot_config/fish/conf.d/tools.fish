#
# tools
#

# Activate the runtimes declared in ~/.config/mise/config.toml.
if command -q mise
    if status is-interactive
        mise activate fish | source
    else
        fish_add_path --append $HOME/.local/share/mise/shims
    end
end

# Enable colors for grep (if not using rg)
if not command -v rg >/dev/null
    alias grep="grep --color=auto"
end

# Tree with colors (if tree is installed and not using eza)
if command -v tree >/dev/null && not command -v eza >/dev/null
    alias tree="tree -C"
end
