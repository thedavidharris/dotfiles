## OSX Stuff - move to custom file


# Make sure we're running OS X
# if [[ "$OSX" != true ]]; then
#   return
# fi

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