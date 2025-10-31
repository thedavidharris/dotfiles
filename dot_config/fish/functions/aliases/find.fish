function find --description 'Alias find to fd (use command find for find-specific options)'
    # If using find-specific options that fd doesn't support, use real find
    # Check for common find options that fd doesn't support
    # Also check for -n which might be a completion request for -name
    set -l find_options -name -iname -n -type -mmin -mtime -atime -ctime -delete -exec -execdir -ok -perm -size -user -group -newer -print -print0 -printf
    for arg in $argv
        if contains -- $arg $find_options
            command find $argv
            return
        end
    end

    # Otherwise, use fd if available
    if command -v fd >/dev/null
        command fd $argv
    else
        command find $argv
    end
end
