# conf.d runs first!
# This file runs AFTER conf.d/ files have been loaded.

# https://fishshell.com/docs/current/tutorial.html
# https://github.com/jorgebucaran/fish-shell-cookbook
# https://github.com/fish-shell/fish-shell/blob/master/share/config.fish
# https://github.com/fish-shell/fish-shell/blob/da32b6c172dcfe54c9dc4f19e46f35680fc8a91a/share/config.fish#L257-L269

# https://github.com/mattmc3/fishconf

# Machine-specific or local configurations that need to run after conf.d/ loads

# Set initial working directory.
set -g IWD $PWD

# Initialize fuzzy finder.
if type -q fzf
    if not test -r $__fish_cache_dir/fzf_init.fish
        fzf --fish >$__fish_cache_dir/fzf_init.fish
    end
    test -s $__fish_cache_dir/fzf_init.fish; and source $__fish_cache_dir/fzf_init.fish
end

# Initialize zoxide for fast jumping with 'z'.
if type -q zoxide
    if not test -r $__fish_cache_dir/zoxide_init.fish
        zoxide init fish >$__fish_cache_dir/zoxide_init.fish
    end
    test -s $__fish_cache_dir/zoxide_init.fish; and source $__fish_cache_dir/zoxide_init.fish
end

# Initialize prject jumping with 'prj'.
if type -q prj
    set -l __prj_init (prj -i fish ^/dev/null)
    if test -n "$__prj_init"
        printf '%s\n' $__prj_init | source
    end
end

# Initialize fnox
if type -q fnox
    if not test -r $__fish_cache_dir/fnox_activate.fish
        fnox activate fish >$__fish_cache_dir/fnox_activate.fish
    end
    test -s $__fish_cache_dir/fnox_activate.fish; and source $__fish_cache_dir/fnox_activate.fish
end

#
# Prompt
#

# Disable new user greeting.
set fish_greeting

# Initialize starship.
if type -q starship
    set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship.toml
    if not test -r $__fish_cache_dir/starship_init.fish
        starship init fish --print-full-init >$__fish_cache_dir/starship_init.fish
    end
    test -s $__fish_cache_dir/starship_init.fish; and source $__fish_cache_dir/starship_init.fish
    enable_transience

    # Start prompt at the bottom
    # tput cup 9999 0
end

# Use vivid for LS_COLORS (matches terminal theme)
if command -v vivid >/dev/null
    set -gx LS_COLORS (vivid generate catppuccin-macchiato)
end

#
# Local
#

if set -q DOTFILES.local; and test -r $DOTFILES.local/fish/config.fish
    source $DOTFILES.local/fish/config.fish
end
