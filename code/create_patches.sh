#!/bin/sh

# Check if at least two .cpp files exist
cpp_files=$(ls -Sr *.cpp 2>/dev/null)
file_count=$(echo "$cpp_files" | wc -l)

if [ "$file_count" -lt 2 ]; then
    echo "Need at least two .cpp files to generate patches."
    exit 1
fi

# Initialize variables
prev_file=""
i=1

# Iterate through sorted .cpp files by size
for current_file in $cpp_files; do
    if [ -n "$prev_file" ]; then
        patch_name="patch_${i}_${prev_file}_to_${current_file}.diff"
        echo "Generating patch: $patch_name"
        diff -u "$prev_file" "$current_file" > "$patch_name"
        i=$((i + 1))
    fi
    prev_file="$current_file"
done

echo "All patches generated."
exit 0
