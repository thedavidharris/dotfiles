function grep --wraps rg --description 'Alias grep to rg (ripgrep)'
    if command -v rg >/dev/null
        command rg $argv
    else
        command grep --color=auto --exclude-dir={.git,.hg,.svn} $argv
    end
end
