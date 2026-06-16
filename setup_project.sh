#!/bin/bash

# This line above tells the computer to use bash to run this script.

# -------------------------------------------------------
# STEP 1: SIGNAL TRAP (Ctrl+C Handler)
# I set this up FIRST so it is active during the whole script.
# If the user presses Ctrl+C at any point, this function runs.
# -------------------------------------------------------

# This is a function called "cleanup". It runs when Ctrl+C is pressed.
cleanup() {

    # Print a blank line and a message to the screen
    echo ""
    echo "You pressed Ctrl+C. The script was interrupted."
    echo "Archiving the incomplete project folder..."

    # Check if the project folder was already created
    # -d means "does this directory exist?"
    if [ -d "$PROJECT_DIR" ]; then

        # Bundle the folder into a compressed archive (.tar.gz)
        tar -czf "${PROJECT_DIR}_archive.tar.gz" "$PROJECT_DIR"

        # Delete the incomplete folder to keep things clean
        rm -rf "$PROJECT_DIR"

        echo "Archive created: ${PROJECT_DIR}_archive.tar.gz"
        echo "Incomplete folder deleted."
    else
        echo "No folder was created yet. Nothing to archive."
    fi

    # Exit the script with code 1 (means something went wrong)
    exit 1
}

# This line tells bash: "When SIGINT (Ctrl+C) happens, run the cleanup function"
trap cleanup SIGINT

# -------------------------------------------------------
# STEP 2: ASK THE USER FOR A PROJECT NAME
# -------------------------------------------------------

echo "Welcome to the Attendance Tracker Setup Script."
echo "Please enter a project name:"

# The read command waits for the user to type something
# and stores it in a variable called INPUT
read INPUT

# I build the folder name using the input the user gave
# For example, if they type "demo", PROJECT_DIR becomes "attendance_tracker_demo"
PROJECT_DIR="attendance_tracker_${INPUT}"

echo "Setting up project: $PROJECT_DIR"

# -------------------------------------------------------
# STEP 3: CREATE THE FOLDER STRUCTURE
# -------------------------------------------------------

# mkdir -p creates the folder and any parent folders needed
# It also does not give an error if the folder already exists
mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

echo "Folders created successfully."

# -------------------------------------------------------
# STEP 4: COPY THE SOURCE FILES INTO THE RIGHT FOLDERS
# -------------------------------------------------------

# cp means "copy". I copy each file to where it belongs.
cp attendance_checker.py "$PROJECT_DIR/attendance_checker.py"
cp assets.csv "$PROJECT_DIR/Helpers/assets.csv"
cp config.json "$PROJECT_DIR/Helpers/config.json"
cp reports.log "$PROJECT_DIR/reports/reports.log"

echo "Files copied into the project folder."

# -------------------------------------------------------
# STEP 5: DYNAMIC CONFIGURATION USING sed
# -------------------------------------------------------

echo ""
echo "The default attendance thresholds are:"
echo "  Warning:  75%"
echo "  Failure:  50%"
echo ""
echo "Do you want to change these values? (yes/no)"
read CHANGE

# Check if the user typed "yes"
if [ "$CHANGE" = "yes" ]; then

    echo "Enter the new Warning threshold (example: 80):"
    read WARNING

    echo "Enter the new Failure threshold (example: 60):"
    read FAILURE

    # sed is a command that finds and replaces text inside a file
    # -i '' means edit the file directly (in-place) on Mac
    # The part in quotes means: find "warning": any number, replace with the new value
    sed -i '' "s/\"warning\": [0-9]*/\"warning\": $WARNING/" "$PROJECT_DIR/Helpers/config.json"
    sed -i '' "s/\"failure\": [0-9]*/\"failure\": $FAILURE/" "$PROJECT_DIR/Helpers/config.json"

    echo "Thresholds updated. Here is the new config.json:"
    cat "$PROJECT_DIR/Helpers/config.json"

else
    echo "Keeping the default thresholds."
fi

# -------------------------------------------------------
# STEP 6: ENVIRONMENT HEALTH CHECK
# -------------------------------------------------------

echo ""
echo "Running environment health check..."
echo "--------------------------------------"

# Check if python3 is installed by running python3 --version
# 2>/dev/null hides any error messages from the screen
if python3 --version 2>/dev/null; then
    echo "Python 3 is installed. Good to go."
else
    echo "Warning: Python 3 was not found. Please install it before running the app."
fi

# Verify that all the required files are in the right place
# -f means "does this file exist?"
if [ -f "$PROJECT_DIR/attendance_checker.py" ] && \
   [ -f "$PROJECT_DIR/Helpers/assets.csv" ] && \
   [ -f "$PROJECT_DIR/Helpers/config.json" ] && \
   [ -f "$PROJECT_DIR/reports/reports.log" ]; then

    echo "All files are in the correct place."
else
    echo "Warning: Some files are missing. Please check the folder structure."
fi

echo "--------------------------------------"
echo "Project $PROJECT_DIR is ready."
