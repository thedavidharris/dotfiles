function du --wraps dust --description 'Alias du to dust'
    if command -v dust >/dev/null
        command dust $argv
    else
        command du $argv
    end
end
