# =============================================================================
# Initialize Fisher Plugin Manager
# Setup Fisher for plugins and configure paths
# =============================================================================

function init_fisher -d "Setup Fisher for plugins"
    set -q fisher_path || set -gx fisher_path $__fish_config_dir/.fisher
    set -q my_plugins_path || set -gx my_plugins_path $__fish_config_dir/plugins

    if test "$fisher_paths_initialized" != true
        set --local idx (contains -i $__fish_config_dir/functions $fish_function_path || echo 1)
        set fish_function_path $fish_function_path[1..$idx] $fisher_path/functions $fish_function_path[(math $idx + 1)..]

        set --local idx (contains -i $__fish_config_dir/completions $fish_complete_path || echo 1)
        set fish_complete_path $fish_complete_path[1..$idx] $fisher_path/completions $fish_complete_path[(math $idx + 1)..]

        set -g fisher_paths_initialized true
    end

    if not test -d $fisher_path
        functions -e fisher &>/dev/null
        mkdir -p $fisher_path
        touch $__fish_config_dir/fish_plugins
        curl -sL https://git.io/fisher | source
        if test -s $__fish_config_dir/fish_plugins
            fisher update
        else
            fisher install jorgebucaran/fisher
        end
    end

    for file in $fisher_path/conf.d/*.fish
        if ! test -f $__fish_config_dir/conf.d/(path basename -- $file)
            and test -f $file && test -r $file
            builtin source $file
        end
    end

    # Symlink fisher themes to make them available
    if test -d $fisher_path/themes
        if test -L $__fish_config_dir/themes
            # Already a symlink, nothing to do
        else if test -e $__fish_config_dir/themes
            # Exists but not a symlink (directory or file), remove it first
            rm -rf $__fish_config_dir/themes
            ln -s $fisher_path/themes $__fish_config_dir/themes
        else
            # Doesn't exist, create symlink
            ln -s $fisher_path/themes $__fish_config_dir/themes
        end
    end
end
