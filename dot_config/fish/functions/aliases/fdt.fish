function fdt --wraps fd --description 'fd directories only'
    command fd -t d $argv
end

