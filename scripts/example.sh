#!/bin/bash
#
startText="\nStarting... ;)"

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

ctrl_c (){
  echo -e "\n\n[+]Saliendo..."
  exit 1
}

trap ctrl_c INT

echo -e $startText

echo -e "\n[+] Your current private WIFI IP is -> $Red $(ip a | grep wlan0 | tail -n 1 | awk '{print $2}' | awk '{print $1}' FS="/") $Color_Off"

echo -e "[+] Your current private LAN  IP is -> $Red $(ip a | grep enp7s0 | tail -n 1 | awk '{print $2}' | awk '{print $1}' FS="/") $Color_Off\n"

echo -e "0035\n14EB" | sort -u | while read line; do echo -e "[+] Puerto $line -> $(echo "obase=10; ibase=16; $line" | bc) $Green -OPEN $Color_Off"; done


