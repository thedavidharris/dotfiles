set -g IWD $PWD
set -g fish_greeting

if status is-interactive
    if command -q fzf
        fzf --fish | source
    end
    if command -q zoxide
        zoxide init fish | source
    end
    if command -q prj
        prj -i fish | source
    end
    if command -q fnox
        fnox activate fish | source
    end
    if command -q starship
        set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship.toml
        starship init fish | source
        functions -q enable_transience; and enable_transience
    end
    if command -q vivid
        set -gx LS_COLORS (vivid generate catppuccin-macchiato)
    end
end

# Local overrides load last.
set -l local_dir $XDG_CONFIG_HOME/fish/local
set -q DOTFILES_LOCAL_FISH_DIR; and set local_dir $DOTFILES_LOCAL_FISH_DIR
for file in $local_dir/conf.d/*.fish
    source $file
end
if test -r $local_dir/config.fish
    source $local_dir/config.fish
end
