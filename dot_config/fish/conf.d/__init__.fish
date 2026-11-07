# Shared paths and defaults for interactive shells and scripts.
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew
    if test -x $brew_bin
        $brew_bin shellenv fish | source
        break
    end
end

# Prefer Homebrew tools over older standalone installs.
fish_add_path --global --prepend (path filter $HOME/bin $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin $HOME/.local/bin $HOME/.cargo/bin)
fish_add_path --global --append (path filter $HOME/Library/Android/sdk/platform-tools $HOME/Android/Sdk/platform-tools)
set -p fish_function_path $__fish_config_dir/functions/aliases

if status is-interactive
    init_fisher
end
