# =============================================================================
# Change Terminal Title
# Set the terminal window/tab title
# =============================================================================

function title -d "Change current terminal title"
    if test (count $argv) -lt 1
        echo "Usage: title <title>" >&2
        echo "You need to specify a title to set" >&2
        return 1
    end

    echo "function fish_title; echo \"$argv\"; end" | source -
end
