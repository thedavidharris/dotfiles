#!/bin/sh
set -eu

asdf_plugin_add() {
    asdf plugin add "$1" "${2:-}" || test $? = 2
}

asdf_plugin_add nodejs
asdf_plugin_add python
asdf_plugin_add ruby