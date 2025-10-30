#
# __init__: Anything that needs to be first.
#

# Set XDG basedirs.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
set -q XDG_CONFIG_HOME; or set -Ux XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -Ux XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME; or set -Ux XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME; or set -Ux XDG_CACHE_HOME $HOME/.cache
for xdgdir in (path filter -vd $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_STATE_HOME $XDG_CACHE_HOME)
    mkdir -p $xdgdir
end

# Ensure manpath is set to something so we can add to it.
set -q MANPATH || set -gx MANPATH ''

# Add more man page paths.
for manpath in (path filter $__fish_data_dir/man /usr/local/share/man /usr/share/man)
    set -a MANPATH $manpath
end

# Allow subdirs for functions and completions.
set fish_function_path (path resolve $__fish_config_dir/functions/*/) $fish_function_path
set fish_complete_path (path resolve $__fish_config_dir/completions/*/) $fish_complete_path

# Setup caching.
if not set -q __fish_cache_dir
    if set -q XDG_CACHE_HOME
        set -U __fish_cache_dir $XDG_CACHE_HOME/fish
    else
        set -U __fish_cache_dir $HOME/.cache/fish
    end
end
test -d $__fish_cache_dir; or mkdir -p $__fish_cache_dir

# Remove expired cache files (older than 20 hours).
find $__fish_cache_dir -name '*.fish' -type f -mmin +1200 -delete; or true

# Setup homebrew.
if not test -s $__fish_cache_dir/brew_init.fish
    if test -e /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv >$__fish_cache_dir/brew_init.fish
    end
end
test -s $__fish_cache_dir/brew_init.fish; and source $__fish_cache_dir/brew_init.fish

# Add bin directories to PATH (deduped, only if they exist).
set -g prepath (
    path filter \
        $HOME/bin \
        $HOME/sbin \
        $HOME/.local/bin \
        $HOME/.local/sbin \
        $HOME/.cargo/bin \
        $ANDROID_HOME/platform-tools \
        $ANDROID_HOME/tools \
        $ANDROID_HOME/tools/bin \
        $HOMEBREW_PREFIX/bin \
        $HOMEBREW_PREFIX/sbin \
        /usr/local/bin \
        /usr/local/sbin \
        /bin
)
fish_add_path --prepend --move $prepath

# Fisher (run after PATH/homebrew is set; only in interactive shells)
if status is-interactive
    init_fisher
end
