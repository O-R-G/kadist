#!/bin/bash

# add comments re accessibility settings

get_screen_dimensions() {
    osascript -e "tell application \"Finder\" to get bounds of window of desktop" | awk '{print $3, $4}'
}

folder_path="/Users/reinfurt/kadist/comp/mp4/"

i=0
pos_x=0
pos_y=0
win_w=550
win_h=200
screen_height=$(get_screen_dimensions | cut -d ' ' -f 2)

# Check if the folder exists
if [ -d "$folder_path" ]; then
    # Change directory to the specified folder
    cd "$folder_path" || exit

    for file in *.mp4; do
        echo "Opening file: $file"  # Print the file being opened for debugging
        echo "pos_x: $pos_x, pos_y: $pos_y"  # Print the values of pos_x and pos_y
        
        full_file_path=$(pwd)/"$file"
        osascript -e "tell application \"QuickTime Player\"
                            activate
                            open POSIX file \"$full_file_path\"
                            # delay 0.1
                            set bounds of front window to {$pos_x, $pos_y, $(($pos_x + 500)), $(($pos_y + 200))}
                            tell front document
                                set looping to true
                                set current time to 0
                                play
                            end tell
                        end tell"        
        ((pos_x += 50))
        ((pos_y += $win_h))

        # check if the window position is below the screen height and reposition it if necessary
        windowPosition=$(osascript -e "tell application \"QuickTime Player\" to get bounds of front window")
        window_y=$(echo "$windowPosition" | awk '{print $4}')
        if [ "$window_y" -gt "$screen_height" ]; then
            ((i++))
            pos_y=0
            pos_x=win_w*i
            osascript -e "tell application \"QuickTime Player\" to set bounds of front window to {$pos_x, 0, $(($pos_x + 500)), 200}"
        fi

        # Set the playback speed using a keystroke (Command + Right Arrow)
        # each keystroke increases from 2x 5x 10x 30x 60x
        osascript -e "tell application \"System Events\" to tell process \"QuickTime Player\" to key code 124 using command down"
        osascript -e "tell application \"System Events\" to tell process \"QuickTime Player\" to key code 124 using command down"
        osascript -e "tell application \"System Events\" to tell process \"QuickTime Player\" to key code 124 using command down"
        osascript -e "tell application \"System Events\" to tell process \"QuickTime Player\" to key code 124 using command down"
        # osascript -e "tell application \"System Events\" to tell process \"QuickTime Player\" to key code 124 using command down"
        # sleep 0.1
    done
else
    echo "Folder does not exist or permission denied: $folder_path"
fi
