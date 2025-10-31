function ls --wraps eza --description 'Alias ls to eza with colors and grouped directories'
    if command -v eza >/dev/null
        command eza --color=always --group-directories-first $argv
    else
        switch (uname -s)
        case Darwin
            /bin/ls -L -G $argv
        case '*'
            /bin/ls -L --group-directories-first --color=auto $argv
      end
    end
end
