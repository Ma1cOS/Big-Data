#!/usr/bin/env bash

# 1. Ensure the output directory exists
mkdir -p exported

# 2. Define your target folders and their prefixes using an associative array
# Format: ["path/to/dir"]="prefix_"
declare -A TARGET_DIRS
TARGET_DIRS=(
    ["../notebooks/"]=""                          # No prefix for the main folder
    ["../notebooks/3b_classification_models/"]="" # No prefix for the other folder
)

export EXPORT_DIR="exported"

# Define the processing logic for a single file
process_file() {
    local f="$1"
    local prefix="$2"
    echo "Processing: $f (Prefix: ${prefix:-none})"

    if nb2pdf "$f"; then
        # Calculate the original generated PDF name
        local base_name
        base_name=$(basename "${f%.*}")
        local pdf_src
        pdf_src="$(dirname "$f")/${base_name}.pdf"

        # Move it to exported/ with the prefix attached to the filename
        mv "$pdf_src" "$EXPORT_DIR/${prefix}${base_name}.pdf"
    fi
}
export -f process_file

# 3. Loop through the array keys to pass files and their specific prefixes to xargs
for DIR in "${!TARGET_DIRS[@]}"; do
    PREFIX="${TARGET_DIRS[$DIR]}"

    # Find files in this specific directory and pass them to xargs
    # -P 4 handles up to 4 parallel jobs at once
    find "$DIR" -maxdepth 1 -name "*.ipynb" -print0 | \
        xargs -0 -I {} -P 4 bash -c 'process_file "{}" '"$PREFIX"''
done
