#!/bin/bash

#----------------------------------------#
# SIMPLE NETWORK SCANNER USING NMAP COMMANDS
# MADE BY: TREVOR J.
#----------------------------------------#

# TO DO 
# FIX THE REGEX IF STATEMENT TO CHECK FOR PROPER IP INPUT

#----------------------------------------#
# VARIABLE LISTS
#----------------------------------------#

# Color Codes
source /home/jobes/scripts/global/color_code.sh

# User, files, and IP variables 
USER=$(whoami)
TIMESTAMP=$(date +"%m-%d-%Y %H:%M:%S")

OUTPUT_DIR="/home/$USER/scan_results"
HOST_FILE="$OUTPUT_DIR/host_scan"
PORT_FILE="$OUTPUT_DIR/port_scan"
SERVICE_FILE="$OUTPUT_DIR/service_scan"
VULN_FILE="$OUTPUT_DIR/vuln_scan"


# User input for IP range stored in IP
read -p "Enter an IP range: " IP

# Checking to see if the user input a correct IP address
regex="^([0-9]{1,3}\.){3}[0-9]{1,3}|255$"

if [[ $IP =~ $regex ]]; then
	echo -e "${GREEN}Vailid IP${NC}"
else
	echo "Invalid IP"
	exit 1
fi

# Creates the scan_results directory if it doesnt exitst already
mkdir -p $OUTPUT_DIR


#----------------------------------------#
# NMAP FUNCTIONS
#----------------------------------------#

function PING {
	echo -e "${BLUE}[*] Discovering Hosts...${NC}"
	echo -e "${GREEN}$TIMESTAMP${NC}" >> $HOST_FILE
	nmap -sn $IP >> $HOST_FILE
}

function PORT {
	echo -e "${PURP}[*] Scanning Ports...${NC}"
	echo -e "${GREEN}$TIMESTAMP${NC}" >> $PORT_FILE
	nmap -p- --open $IP >> $PORT_FILE
}

function SERVICE {
	echo -e "${BLUE}[*] Detecting Services and Versions...${NC}"
	echo -e "${GREEN}$TIMESTAMP${NC}" >> $SERVICE_FILE
	nmap -sV $IP >> $SERVICE_FILE
}

function VULN {
	echo -e "${PURP}[*} Detecting Basic Vulns...${NC}"
	echo -e "${GREEN}$TIMESTAMP${NC}" >> $VULN_FILE
	nmap --script vuln $IP >> $VULN_FILE
}


#----------------------------------------#
# SCAN MENU
#----------------------------------------#

echo "1) Ping Scan"
echo "2) Port Scan"
echo "3) Service Scan"
echo "4) Basic Vulnerability Scan"
echo "5) All"
read -p "Please select the scans you want to execute: " choices


#----------------------------------------#
# FOR LOOP TO EXECUTE USER'S CHOSEN SCANS
#----------------------------------------#

for choice in $choices; do 
	case $choice in 
		1) 
			PING 
			;;
		2) 
			PORT 
			;;
		3) 
			SERVICE 
			;;
		4) 
			VULN 
			;;
		5) 
			PING
			PORT
			SERVICE
			VULN 
			;;
		*) 
			echo -e "Invalid input: ${RED}$choices${NC}"
			echo -e "Please chose ${GREEN}1-5${NC}."
			exit 1 
	esac
done


#----------------------------------------#
# STATEMENTS TO CONFIRM THE SCRIPT HAS FINISHED 
#----------------------------------------#

echo -e "${GREEN}Scan Complete!${NC}"
echo -e "Your scans have been saved in ${GREEN}$OUTPUT_DIR${NC}"
echo -e "Thank you for using ${BLUE}net_scan${NC}."

