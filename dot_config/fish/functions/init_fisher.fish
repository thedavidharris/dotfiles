function init_fisher --description 'Load installed Fish plugins'
    set -gx fisher_path $__fish_config_dir/.fisher
    set -p fish_function_path $fisher_path/functions
    set -p fish_complete_path $fisher_path/completions

    for file in $fisher_path/conf.d/*.fish
        if not test -f $__fish_config_dir/conf.d/(path basename $file)
            source $file
        end
    end
    if test -d $fisher_path/themes; and not test -e $__fish_config_dir/themes; and not test -L $__fish_config_dir/themes
        ln -s $fisher_path/themes $__fish_config_dir/themes
    end
end
