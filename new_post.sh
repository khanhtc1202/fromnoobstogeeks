#!/bin/bash

# parse params
while [[ -z "$1" ]]
do
    echo "Missing post's name..."
    exit 1
done

# define var
TEMP="---\ntitle:\ndate: $(date +"%Y-%m-%d %T")\ntags:\n---\n\n\n<!-- more -->\n"
SRC_DIR="./source/_posts/"
MD_PATH=$SRC_DIR$1".md"

echo -e $TEMP > $MD_PATH
echo "Your new post source file located on $MD_PATH"
