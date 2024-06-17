#!/bin/bash
#  Pico Build Action - Entrypoint script, this builds the code.
#  Copyright 2024 Samyar Sadat Akhavi
#  Written by Samyar Sadat Akhavi, 2024.
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https: www.gnu.org/licenses/>.

set -e

# Define binary file extensions and build directories to ignore
DEFAULT_IGNORED_BUILD_DIRS=("CMakeFiles" "elf2uf2" "pico-sdk" "pioasm")

# Get arguments
SOURCE_DIR="$1"
OUTPUT_DIR="$2"
OUTPUT_EXT="$3"
BOARD_NAME="$4"
CMAKE_ARGS="$5"
OUTPUT_IGNORED_DIRS="$6"
CMAKE_CONFIG_ONLY="$7"

# Split output extensions and into array
IFS=" " read -r -a BINARY_EXTENSIONS <<< "$OUTPUT_EXT"

# Split ignored build directories into array and append to IGNORED_BUILD_DIRS
IFS=" " read -r -a IGNORED_BUILD_DIRS <<< "$OUTPUT_IGNORED_DIRS"
IGNORED_BUILD_DIRS=("${DEFAULT_IGNORED_BUILD_DIRS[@]}" "${IGNORED_BUILD_DIRS[@]}")

# Validate arguments
if [ -z "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not provided."
    exit 1
fi

if [ -z "$OUTPUT_DIR" ]; then
    echo "ERROR: Output directory not provided."
    exit 1
fi

if [ -z "$BOARD_NAME" ]; then
    BOARD_NAME="pico"
fi

if [ -z "$BINARY_EXTENSIONS" ]; then
    BINARY_EXTENSIONS=("*.uf2" "*.elf" "*.elf.map")
fi

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory does not exist."
    exit 1
fi

# Make paths absolute
OUTPUT_DIR_RELATIVE="$SOURCE_DIR/$OUTPUT_DIR"
SOURCE_DIR="$GITHUB_WORKSPACE/$SOURCE_DIR"
OUTPUT_DIR="$SOURCE_DIR/$OUTPUT_DIR"

# Echo arguments
echo "Configuration:"
echo "SOURCE_DIR=$SOURCE_DIR"
echo "OUTPUT_DIR=$OUTPUT_DIR"
echo "BINARY_EXTENSIONS=${BINARY_EXTENSIONS[@]}"
echo "BOARD_NAME=$BOARD_NAME"
echo "CMAKE_ARGS=$CMAKE_ARGS"
echo "IGNORED_BUILD_DIRS=${IGNORED_BUILD_DIRS[@]}"

# Build the project
echo "Generating build files..."
mkdir "$OUTPUT_DIR" && cd "$OUTPUT_DIR"
cmake -DPICO_BOARD="$BOARD_NAME" $CMAKE_ARGS -S "$SOURCE_DIR" -B "$OUTPUT_DIR"

if [ "$CMAKE_CONFIG_ONLY" = "false" ]; then
    echo "Building project..."
    make -j$(nproc)

    # Remove ignored build directories
    echo "Removing unnecessary build directories..."
    for dir in "${IGNORED_BUILD_DIRS[@]}"; do
        if [ -d "$OUTPUT_DIR/$dir" ]; then
            echo "Removing $dir..."
            rm -rf "$OUTPUT_DIR/$dir"
        fi
    done

    # Move the build artifacts to temporary directory
    echo "Moving build artifacts to temporary directory..."
    COPY_DEST_DIR="/tmp/make_build"
    for ext in "${BINARY_EXTENSIONS[@]}"; do
        find "$OUTPUT_DIR" -name "$ext" -print0 | while IFS= read -r -d '' file; do
            echo "Copying $file..."
            relative_path="${file#$OUTPUT_DIR/}"
            mkdir -p "$COPY_DEST_DIR/$(dirname "$relative_path")"
            cp "$file" "$COPY_DEST_DIR/$relative_path"
        done
    done

    # Clear the build directory
    echo "Clearing the build directory..."
    rm -rf "$OUTPUT_DIR" && mkdir "$OUTPUT_DIR"

    # Move the build artifacts back to the output directory
    echo "Moving build artifacts back to the output directory..."
    mv /tmp/make_build/* "$OUTPUT_DIR"
fi

# Add output directory path to GITHUB_OUTPUT
echo "output_dir=$OUTPUT_DIR_RELATIVE" >> $GITHUB_OUTPUT