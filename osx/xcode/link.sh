#!/bin/bash
#
# If you change these files in the Xcode UI, it will remove the symlinks and
# duplicate them. In that case you should copy them back to this repo, and
# re-run this script.
#
# http://www.openradar.me/42206958
#

set -e
set -o pipefail
set -u

if [ ! -d xcode ]; then
  echo "Must be run from root of dotfiles"
  exit 1
fi

colors="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
rm -f "$colors/panic.xccolortheme"
rm -f "$colors/gruvbox-dark.xccolortheme"
rm -f "$colors/gruvbox-light.xccolortheme"
mkdir -p "$colors"
ln -s "$DOTFILES/xcode/panic.xccolortheme" "$colors"
ln -s "$DOTFILES/xcode/gruvbox-dark.xccolortheme" "$colors"
ln -s "$DOTFILES/xcode/gruvbox-light.xccolortheme" "$colors"
