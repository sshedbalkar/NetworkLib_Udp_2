#!/bin/bash

shopt -s extglob    # enable shell options: extra matching patterns
echo Cleaning build...
cd ../build
rm -rf ./**/!(*.gitignore|*.sh|*.cmd) 2> /dev/null    # delete all subfolders except the ones that have files in the parenthesis and send warnings to dev/null
rm -f !(*.gitignore|*.sh|*.cmd) 2> /dev/null    # delete all files execpt the ones in the parenthesis and send warnings to dev/null
rmdir ./!(debug|release) 2> /dev/null    # remove all directories except these two and send warnings to dev/null
