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

# Initialize project jumping with 'prj'.
if type -q prj
    if not test -r $__fish_cache_dir/prj_init.fish
        prj -i fish >$__fish_cache_dir/prj_init.fish 2>/dev/null
    end
    test -s $__fish_cache_dir/prj_init.fish; and source $__fish_cache_dir/prj_init.fish
end

# Initialize fnox
# if type -q fnox
#     if not test -r $__fish_cache_dir/fnox_activate.fish
#         fnox activate fish >$__fish_cache_dir/fnox_activate.fish
#     end
#     test -s $__fish_cache_dir/fnox_activate.fish; and source $__fish_cache_dir/fnox_activate.fish
# end

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
    if not test -r $__fish_cache_dir/vivid_ls_colors.fish
        echo "set -gx LS_COLORS '$(vivid generate catppuccin-macchiato)'" >$__fish_cache_dir/vivid_ls_colors.fish
    end
    test -s $__fish_cache_dir/vivid_ls_colors.fish; and source $__fish_cache_dir/vivid_ls_colors.fish
end

#
# Local
#

# Local machine/work overrides (untracked)
set -l __local_fish_dir "$XDG_CONFIG_HOME/fish/local"
set -q DOTFILES_LOCAL_FISH_DIR; and set __local_fish_dir "$DOTFILES_LOCAL_FISH_DIR"

set -l __local_conf_dir "$__local_fish_dir/conf.d"
if test -d "$__local_conf_dir"
    for f in $__local_conf_dir/*.fish
        test -r "$f"; and source "$f"
    end
end

if test -r "$__local_fish_dir/config.fish"
    source "$__local_fish_dir/config.fish"
end
