#!/bin/bash

# Specify the folder containing the MP4 files
folder_path="/Users/reinfurt/kadist/comp/mp4/"

# Define the initial window position coordinates
pos_x=50
pos_y=50

# Check if the folder exists
if [ -d "$folder_path" ]; then
    # Change directory to the specified folder
    cd "$folder_path" || exit

    # Loop through MP4 files and open with QuickTime Player
    for file in *.mp4; do
        echo "Opening file: $file"  # Print the file being opened for debugging
        full_file_path=$(pwd)/"$file"
        osascript -e "tell application \"QuickTime Player\"
                            activate
                            open POSIX file \"$full_file_path\"
                            delay 1
                            tell front document
                                set looping to true
                                set current time to 0
                                set rate to 2
                                play
                            end tell
                            set the bounds of front window to {$pos_x, $pos_y, $(($pos_x + 500)), $(($pos_y + 200))}
                        end tell"
        
        # Adjust window position for the next file
        ((pos_x += 50))
        ((pos_y += 200))
    done
else
    echo "Folder does not exist or permission denied: $folder_path"
fi
'
