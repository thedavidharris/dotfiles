function ps --wraps procs --description 'Alias ps to procs'
    if command -v procs >/dev/null
        command procs $argv
    else
        command ps $argv
    end
end
