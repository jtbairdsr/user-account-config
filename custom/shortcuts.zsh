#!/bin/bash

SHORTCUTS=(${(s:
:)"$(ls ~/.shortcuts)"})

for x in "${SHORTCUTS[@]}"; do
    [ -d ~/.shortcuts ] || mkdir ~/.shortcuts
    [ -f ~/."$x" ] && mv ~/."$x" ~/.shortcuts/"$x"
    [ -f ~/.shortcuts/"$x" ] || echo "$HOME" > ~/.shortcuts/"$x"
    export "$x"="$(cat ~/.shortcuts/"$x")"
    alias set$x="$x=\`pwd\`;echo \$$x > ~/.shortcuts/$x"
    alias $x="cd \"\$$x\"; pwd"
    hash -d "$x"
done
