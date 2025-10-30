# =============================================================================
# Trash Files (safer than rm)
# Move files to trash instead of permanently deleting
# =============================================================================

function trash -d "Move files to trash (safer than rm)"
    if test (count $argv) -eq 0
        echo "Usage: trash <file>..."
        return 1
    end

    for item in $argv
        if not test -e $item
            echo "❌ '$item' does not exist" >&2
            continue
        end

        # macOS
        if command -v trash >/dev/null 2>&1
            # Use trash CLI if available (brew install trash)
            trash $item
            echo "🗑️  Moved to trash: $item"
        else if test (uname) = "Darwin"
            # macOS fallback using AppleScript
            osascript -e "tell application \"Finder\" to delete POSIX file \"(realpath $item)\"" >/dev/null 2>&1
            echo "🗑️  Moved to trash: $item"
        # Linux
        else if command -v gio >/dev/null 2>&1
            gio trash $item
            echo "🗑️  Moved to trash: $item"
        else
            echo "❌ No trash utility found. Use 'rm' if you really want to delete." >&2
            return 1
        end
    end
end

