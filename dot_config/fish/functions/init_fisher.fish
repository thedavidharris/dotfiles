#
# Setup Fisher for plugins.
#
function init_fisher
    set -q fisher_path || set -gx fisher_path $__fish_config_dir/.fisher
    set -q my_plugins_path || set -gx my_plugins_path $__fish_config_dir/plugins

    if test "$fisher_paths_initialized" != true
        set --local idx (contains -i $__fish_config_dir/functions $fish_function_path || echo 1)
        set fish_function_path $fish_function_path[1..$idx] $fisher_path/functions $fish_function_path[(math $idx + 1)..]

        set --local idx (contains -i $__fish_config_dir/completions $fish_complete_path || echo 1)
        set fish_complete_path $fish_complete_path[1..$idx] $fisher_path/completions $fish_complete_path[(math $idx + 1)..]

        set -g fisher_paths_initialized true
    end

    # Ensure Fisher is available and plugins are synchronized.
    if not test -d $fisher_path
        mkdir -p $fisher_path
    end

    # Prefer Homebrew-installed fisher; warn if missing (no curl bootstrap).
    if type -q fisher
        touch $__fish_config_dir/fish_plugins
        if status is-interactive; and test -s $__fish_config_dir/fish_plugins
            fisher update
        end
    else
        echo "fisher not found. Install it with Homebrew: brew install fisher" 1>&2
    end

    for file in $fisher_path/conf.d/*.fish
        if test -f "$file" && test -r "$file"
            set -l basename (path basename -- "$file")
            if ! test -f $__fish_config_dir/conf.d/$basename
                builtin source "$file"
            end
        end
    end
end
