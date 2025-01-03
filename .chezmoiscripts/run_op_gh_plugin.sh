#!/bin/bash

if [ ! -f ~/.config/op/plugins/gh.json ]; then
    # Initialize the op gh plugin for the default (personal)
    echo "Set up op gh plugin for personal token..."
    cd $HOME
    op plugin init gh
fi

if [ ! -f ~/Developer/work/.op/plugins/gh.json ]; then
    # Initialize the op gh plugin for the default directory (personal)
    echo "Set up op gh plugin for work token..."
    cd $HOME
    op plugin init gh
fi
