function cat --wraps bat --description 'Alias cat to bat --paging=never'
    if command -v bat >/dev/null
        command bat --paging=never $argv
    else
        command cat $argv
    end
end
