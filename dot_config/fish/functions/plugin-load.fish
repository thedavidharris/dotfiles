# =============================================================================
# Load Local Plugins
# Load fish plugins from local plugin directory
# =============================================================================

function plugin-load -d "Load local plugins"
    if test (count $argv) -eq 0
        echo "Usage: plugin-load <plugin>..." >&2
        return 1
    end

    for plugin in $argv
        set --local plugin_dir "$__fish_config_dir/plugins/$plugin"
        if not test -d "$plugin_dir"
            echo "Error: Plugin directory not found: '$plugin_dir'." >&2
            return 1
        end
        test -d $plugin_dir/completions; and set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
        test -d $plugin_dir/functions; and set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
        test -f $plugin_dir/config.fish; and builtin source "$plugin_dir/config.fish"
        for conffile in $plugin_dir/conf.d/*.fish
            builtin source "$conffile"
        end
    end
end
