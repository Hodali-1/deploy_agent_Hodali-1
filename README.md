# deploy_agent_Hodali-1

## Description
A bash script that automatically sets up a Student Attendance Tracker project structure.

## Requirements
- Mac or Linux
- Bash
- Python 3

## How to Run
Open your terminal, navigate to the project folder and run:

    bash setup_project.sh

The script will ask you for a project name and guide you through the rest.

## What the Script Does
1. Asks the user for a project name
2. Creates the following folder structure:

    attendance_tracker_{name}/
        attendance_checker.py
        Helpers/
            assets.csv
            config.json
        reports/
            reports.log

3. Asks if you want to update the attendance thresholds in config.json
4. Uses sed to update the values in config.json if you say yes
5. Checks if Python 3 is installed on your machine
6. Verifies that all files are in the correct place

## How to Trigger the Archive Feature
1. Run the script with: bash setup_project.sh
2. Type a project name and press Enter
3. When you see "Folders created successfully", press Ctrl+C
4. The script will automatically create an archive of the incomplete folder
5. The incomplete folder will then be deleted to keep things clean
