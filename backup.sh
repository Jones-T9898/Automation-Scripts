#!/bin/bash

#+++++++++++++++++++++++++++++++++++++++++++++++++++++#
# SCRIPT TO BACK UP AND TAR A DIRECTORY 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++#

# Color codes"
source /home/jobes/scripts/global/color_code.sh


# Creates a backup directory if not made already
USER=$(whoami)
BACKUP_DIR="/home/$USER/backup"
mkdir -p $BACKUP_DIR


# Directory compressing function
function COMPRESS {
	for dir in $choices; do
		echo -e "${GREEN}Compressing $dir...${NC}"
		tar -czf "/$BACKUP_DIR/$dir.tar.gz" "$dir"
	done
}

# User input for directories to compress
read -p "Which directories would you like to backup? " choices



# Checks to see if user gave input
if [ -z "$choices" ]; then
	echo "No input. Please enter a directory."
	exit 1
fi


# Check to see if directory has contents
for dir in $choices; do
	find "/home/$(whoami)/$dir" -mindepth 1 | read var	
	echo ${#var}
	if [[ "${#var}"  -gt 0  ]]; then
		echo "This directory has content."
#		COMPRESS
	else
		echo "$dir has no content to compress."
		continue
	fi
done 
