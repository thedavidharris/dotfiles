# =============================================================================
# Copy Path to Clipboard
# Copy the current directory path or specified path to clipboard
# =============================================================================

function copypath -d "Copy current directory or specified path to clipboard"
    set -l path_to_copy

    if test (count $argv) -eq 0
        # Copy current directory
        set path_to_copy $PWD
    else if test -e $argv[1]
        # Copy specified file/directory path
        set path_to_copy (realpath $argv[1])
    else
        echo "Error: '$argv[1]' does not exist" >&2
        return 1
    end

    # Copy to clipboard (macOS)
    if command -v pbcopy >/dev/null 2>&1
        echo -n $path_to_copy | pbcopy
        echo "📋 Copied to clipboard: $path_to_copy"
    else if command -v xclip >/dev/null 2>&1
        # Linux with xclip
        echo -n $path_to_copy | xclip -selection clipboard
        echo "📋 Copied to clipboard: $path_to_copy"
    else if command -v wl-copy >/dev/null 2>&1
        # Wayland
        echo -n $path_to_copy | wl-copy
        echo "📋 Copied to clipboard: $path_to_copy"
    else
        echo "❌ No clipboard utility found (pbcopy, xclip, or wl-copy)" >&2
        return 1
    end
end

