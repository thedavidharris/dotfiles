# =============================================================================
# Help Function
# Display help for a command or function
# =============================================================================

function help -d "Display help for commands and functions"
    if test (count $argv) -eq 0
        echo "Usage: help <command|function>"
        echo ""
        echo "Available custom functions:"
        functions | grep -v "^_" | sort
        return
    end

    set -l cmd $argv[1]

    # Check if it's a Fish function
    if functions -q $cmd
        # Show function description
        functions -D $cmd
        echo ""
        # Show function definition
        functions $cmd
    else if command -v $cmd >/dev/null 2>&1
        # Show man page or help
        if man $cmd >/dev/null 2>&1
            man $cmd
        else
            $cmd --help 2>&1 | less
        end
    else
        echo "❌ '$cmd' not found" >&2
        return 1
    end
end

