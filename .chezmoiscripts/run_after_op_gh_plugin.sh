#!/bin/bash

if [ ! -f ~/.config/op/plugins/gh.json ]; then
    # Initialize the op gh plugin for the default (personal)
    echo "Set up op gh plugin..."
    cd $HOME
    op plugin init gh
fi
