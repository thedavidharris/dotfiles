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
    set -l output

    # Check if it's a Fish function
    if functions -q $cmd
        # Show function description
        set output (functions -D $cmd)
        set output $output ""
        # Show function definition
        set output $output (functions $cmd)

        # Pipe to bat if available, otherwise just echo
        if command -v bat >/dev/null 2>&1
            printf '%s\n' $output | bat --plain --language=help
        else
            printf '%s\n' $output
        end
    else if command -v $cmd >/dev/null 2>&1
        # Show man page or help
        if man $cmd >/dev/null 2>&1
            man $cmd
        else
            # Pipe --help output to bat if available
            if command -v bat >/dev/null 2>&1
                $cmd --help 2>&1 | bat --plain --language=help
            else
                $cmd --help 2>&1 | less
            end
        end
    else
        echo "❌ '$cmd' not found" >&2
        return 1
    end
end

