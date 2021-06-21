#!/bin/bash

CMAKE_BUILD_TYPE='Debug'
COMMANDS_FILE='./build/debug/compile_commands.json'

if [ "$1" = "r" ]; then
	CMAKE_BUILD_TYPE='Release'
    COMMANDS_FILE='./build/release/compile_commands.json'
fi

pwd
cd ./scripts/
bash ./lnx_clean.sh
bash ./lnx_build.sh "$CMAKE_BUILD_TYPE"

# Create a symlink to the compile_commands file for clangd to function correctly
cd ..
if [ -f compile_commands.json ]; then
    ln -sfn "$COMMANDS_FILE" compile_commands.json
else 
    ln -s "$COMMANDS_FILE" compile_commands.json
fi


