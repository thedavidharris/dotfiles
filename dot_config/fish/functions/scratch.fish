# Create and edit a temporary file
# Usage: scratch [filename]
function scratch
    if test (count $argv) -eq 0
        # Create temp file with random name
        set file (mktemp)
    else
        # Create temp file with specified name
        set file (mktemp --suffix="-$argv[1]")
    end

    echo "Editing temporary file: $file"
    $EDITOR "$file"
end
