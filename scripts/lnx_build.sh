#!/bin/bash

CMAKE_BUILD_TYPE='Debug'
CMAKE_TARGET='all'

if [ -n "$1" ]; then
	CMAKE_BUILD_TYPE=$1
fi

if [ -n "$2" ]; then
	CMAKE_TARGET=$2
fi

CMAKE_BINARY_DIR=`echo "../build/$CMAKE_BUILD_TYPE" | tr '[:upper:]' '[:lower:]'`

echo "Bin dir: $CMAKE_BINARY_DIR"

if [ ! -f "$CMAKE_BINARY_DIR/Makefile" ]; then
	cmake -H".." -B"$CMAKE_BINARY_DIR" -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" -G"Unix Makefiles"
	if [ $? -ne 0 ]; then
		echo "Error building Makefile"
		exit 1
	fi
fi

cmake --build "$CMAKE_BINARY_DIR" --target "$CMAKE_TARGET" --config "$CMAKE_BUILD_TYPE"
if [ $? -ne 0 ]; then
	echo "Error building project"
	exit 1
fi

echo "Build successful!"
