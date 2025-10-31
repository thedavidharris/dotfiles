#
# abbrs
#

set -q MY_ABBRS_INITIALIZED; and return

# =============================================================================
# NAVIGATION ABBREVIATIONS
# =============================================================================

abbr -a -- - 'cd -'
abbr -a -- .. "cd .."
abbr -a -- ... "cd ../.."
abbr -a -- .... "cd ../../.."
abbr -a -- ..... "cd ../../../.."

abbr -a -- fconf 'cd $__fish_config_dir'
abbr -a -- fishconf 'cd $__fish_config_dir'
abbr -a -- fdot 'cd $__fish_config_dir'
abbr -a -- zdot 'cd $ZDOTDIR'

# Enable aliases to be sudo'ed
abbr -a -- sudo "sudo "

# Reload the shell
abbr -a -- reload "exec fish -l"

# no need to run over-and-over
set -g MY_ABBRS_INITIALIZED true
