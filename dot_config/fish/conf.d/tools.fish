#
# tools
#

# 1Password CLI integration
if type -q op
    alias gh="op plugin run -- gh"
end

# Enable colors for grep (if not using rg)
if not command -v rg >/dev/null
    alias grep="grep --color=auto"
end

# Tree with colors (if tree is installed and not using eza)
if command -v tree >/dev/null && not command -v eza >/dev/null
    alias tree="tree -C"
end
