# =============================================================================
# Copy Current Working Directory
# Copy the full current directory path to clipboard
# =============================================================================

function cpwd -d "Copy current directory path to clipboard"
    if command -v pbcopy >/dev/null 2>&1
        echo -n $PWD | pbcopy
        echo "📋 Copied: $PWD"
    else if command -v xclip >/dev/null 2>&1
        echo -n $PWD | xclip -selection clipboard
        echo "📋 Copied: $PWD"
    else
        echo $PWD
    end
end

