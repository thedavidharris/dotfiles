function tree --wraps eza --description 'Alias tree to eza --tree'
    if command -v eza >/dev/null
        command eza --tree $argv
    else if command -v tree >/dev/null
        command tree $argv
    else
        echo "tree: command not found" >&2
        return 1
    end
end
