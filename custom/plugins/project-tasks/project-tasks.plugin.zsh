#!/bin/bash

projects=( $(task projects | grep -o '^[a-zA-Z][a-zA-Z0-9\-]*' | sed -n '1!p') )

for x in "${projects[@]}"; do
    alias $x="task project:$x"
done
