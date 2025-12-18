function rgu --wraps rg --description 'rg unrestricted (ignore .gitignore)'
    command rg -uu $argv
end

