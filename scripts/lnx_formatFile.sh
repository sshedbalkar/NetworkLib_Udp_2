#!/bin/bash

# echo "Args: $# : $@"
# # store arguments in a special array
# args=("$@")
# # get number of elements
# ELEMENTS=${#args[@]}

# # echo each element in array
# # for loop
# for (( i=0;i<$ELEMENTS;i++)); do
#     echo ${args[${i}]}
# done

# if [ -z "$1" ]; then
#     echo "Required input file"
#     exit 1
# fi

# echo "File: $1"
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"

#echo "Filename: $filename, ext: $extension"

cpp_files=( c cpp h hpp cc )

for item in "${cpp_files[@]}"; do
    if [[ $extension == "$item" ]]; then
        clang-format -i "$1"
        exit 0
    fi
done

exit 0
