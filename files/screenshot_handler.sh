#!/bin/bash

# Create the Screenshots directory if it doesn't exist
mkdir -p ~/Desktop/Screenshots

# Find all screenshot files on the Desktop (non-recursive)
IFS=$'\n' read -d '' -r -a screenshots < <(find ~/Desktop -maxdepth 1 -name "Screenshot*.png" -print0 | xargs -0 ls -t)

# Keep the 3 most recent screenshots
to_keep=("${screenshots[@]:0:3}")

# Move the rest to the Screenshots directory
for screenshot in "${screenshots[@]:3}"; do
    # Extract the year and month from the file's modification time
    year=$(date -r "$screenshot" +"%Y")
    month=$(date -r "$screenshot" +"%m")
    
    # Create the target directory if it doesn't exist
    target_dir=~/Desktop/Screenshots/$year/$month
    mkdir -p "$target_dir"
    
    # Move the screenshot
    mv "$screenshot" "$target_dir"
done
