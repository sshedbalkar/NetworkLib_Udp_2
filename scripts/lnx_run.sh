#!/bin/bash

BUILD_TYPE="debug"
BINARY_DIR='../bin/debug/bin'
if [ "$1" = "r" ]; then
	BUILD_TYPE='release'
    BINARY_DIR='../bin/release/bin'
fi

cd $BINARY_DIR

apps=()
while IFS=  read -r -d $'\0'; do
    apps+=("$REPLY")
done < <(find . -type f -perm +ugo+x -print0)

if [ ${#apps[@]} -eq 0 ]; then
    echo No Executable found!
else
    echo Running build: "$BINARY_DIR" "${apps[0]}"
    ${apps[0]}
fi