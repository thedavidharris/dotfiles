# =============================================================================
# Make Directory and Change Into It
# Create a directory and change into it in one command
# =============================================================================

function mkcd -d "Create directory and change into it"
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory>" >&2
        return 1
    end
    mkdir -p $argv[1] && cd $argv[1]
end
