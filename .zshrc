# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

zstyle ':znap:*' plugins-dir $DOTFILES/zsh/plugins
source $DOTFILES/zsh/zsh-snap/znap.zsh


# Prompt
znap prompt pure

# Oh-My-Zsh Extensions
znap source ohmyzsh/ohmyzsh lib/{completion,nvm}

znap source ohmyzsh/ohmyzsh plugin/chruby
znap source ohmyzsh/ohmyzsh plugin/git
znap source ohmyzsh/ohmyzsh plugin/jenv
znap source ohmyzsh/ohmyzsh plugin/npm
znap source ohmyzsh/ohmyzsh plugin/nvm
znap source ohmyzsh/ohmyzsh plugin/osx

# Options
# setopt autocd autopushd cdsilent chaselinks pushdignoredups pushdsilent
# setopt NO_caseglob extendedglob globdots globstarshort nullglob numericglobsort
# setopt histfcntllock histignorealldups histsavenodups sharehistory
# setopt NO_flowcontrol interactivecomments rcquotes

# Environment variables
# export LANG='en_US.UTF-8'
# export EDITOR='code'
# export VISUAL='code'
# export CLICOLOR=1
# export CLICOLOR_FORCE=1

# Syntax highlighting in `less` and `man`
export PAGER='less'
export LESS='-giR'
export READNULLCMD='bat'
export MANPAGER="sh -c 'col -bpx | bat -l man -p'"
export BAT_PAGER="less $LESS"

# Completions
znap source zsh-users/zsh-completions

# Real-time auto-completion
# https://github.com/marlonrichert/zsh-autocomplete
# znap source marlonrichert/zsh-autocomplete

# In-line suggestions
znap source zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=( "${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[@]:#*forward-char}" )
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=( forward-char vi-forward-char )

# Better line editing tools
# https://github.com/marlonrichert/zsh-edit
znap source marlonrichert/zsh-edit
WORDCHARS='*?\'

# History editing tools
# https://github.com/marlonrichert/zsh-hist
znap source marlonrichert/zsh-hist
bindkey '^[q' push-line-or-edit

# Colors
# https://github.com/marlonrichert/
znap source marlonrichert/zcolors
znap eval zcolors "zcolors ${(q)LS_COLORS}"

# Command-line syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting

##############################
##        Env Stuff         ##
##############################

## Env - move to custom file

if [[ $OSTYPE == darwin* ]]; then
  export OSX=true
fi

# Set the path to include:
#  - $HOME/.bin       for local tools
#  - /usr/local/bin   for Homebrew
#  - /usr/local/sbin
#  - /usr/bin         for system executables
#  - /usr/sbin
#  - /bin
#  - /sbin
export PATH="$HOME/.bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

# Set default editor to Vim
export EDITOR=vim

# i - Vim's smart case
# j.5 - Center search results
# K - Quit on CTRL-C
# M - Longer prompt
# R - output colors correctly
# X - Don't send clear screen signal
export LESS="ij.5KMRX"
export PAGER="less"

# Disable ^-S in the terminal
stty -ixon -ixoff

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty)

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Source something from all shells for private ENV vars
if [[ -f "$HOME/.secrets" ]]; then
  source "$HOME/.secrets"
fi

##############################
##        OSX Stuff         ##
##############################

# Disable fastlane stuff
export FASTLANE_OPT_OUT_USAGE=1
export FASTLANE_SKIP_UPDATE_CHECK=1

# Disable CocoaPods stats
export COCOAPODS_DISABLE_STATS=1

# Disable homebrew analytics
export HOMEBREW_NO_ANALYTICS=1
# Disable crazy characters in brew
export HOMEBREW_NO_EMOJI=1
# Stop homebrew from auto-updating
export HOMEBREW_NO_AUTO_UPDATE=1
# Stop homebrew from running cleanup automatically
export HOMEBREW_NO_INSTALL_CLEANUP=1

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Remove all items from the dock
alias cleardock="defaults write com.apple.dock persistent-apps -array \"\" && killall Dock"

# Xcode commands which are not linked
alias simctl="xcrun simctl"

# lldb doesn't work with brewed python
# https://github.com/Homebrew/homebrew-core/issues/2730
# https://github.com/Homebrew/legacy-homebrew/issues/47201
alias lldb='PATH="/usr/bin" lldb'
alias swift='PATH="/usr/bin" swift'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

##############################
##        Aliases           ##
##############################

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable aliases to be sudo’ed
# May not be needed
alias sudo='sudo '

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

alias hextrip='cat /dev/urandom | hexdump -e "`echo $COLUMNS*1.0/3.0 | bc`/1 \"%02x \" \"\n\"" | lolcat -F 0.01'