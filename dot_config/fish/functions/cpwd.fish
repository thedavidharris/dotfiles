# =============================================================================
# Get Current Working Directory Basename
# =============================================================================

function cpwd -d "Copy current directory basename"
    set -l dir_name (basename $PWD)

    if command -v pbcopy >/dev/null 2>&1
        echo -n $dir_name | pbcopy
        echo "📋 Copied: $dir_name"
    else if command -v xclip >/dev/null 2>&1
        echo -n $dir_name | xclip -selection clipboard
        echo "📋 Copied: $dir_name"
    else
        echo $dir_name
    end
end

