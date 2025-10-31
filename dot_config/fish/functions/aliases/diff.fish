function diff --wraps delta --description 'Alias diff to delta'
    if command -v delta >/dev/null
        command delta $argv
    else
        command diff $argv
    end
end
