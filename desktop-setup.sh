#! /bin/bash

# Color definitions
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'
USERHOME='/home/trude'

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}${BOLD}[!] This script must be run as root.${NC}"
   exit 1
fi

# ------------------- Update OS -------------------

clear
echo -e "${RED}[+] Updating the OS...${NC}"
apt update
apt upgrade -y
echo -e "${RED}[i] done.${NC}"


# ----------------- Install SUDO ---------------

echo ""
echo -e "${RED}[+] Installing Sudo...${NC}"
apt install -y sudo
echo -e "${RED}[i] done.${NC}"

sudo -v
if [ $? != 0 ]
then
	echo ""
	echo -e "${RED}[+] Adding trude to sudoers...${NC}"
	# Add the user to the sudo group
	usermod -aG sudo trude
	echo "trude ALL=(ALL) ALL" >> /etc/sudoers
else
	echo ""
	echo -e "${RED}[i] User already in sudoers.${NC}"
fi



# ----------------- Install Desktop ---------------
echo ""
echo -e "${RED}[+] Installing Sway...${NC}"
apt install -y sway swaybg swaylock foot wofi waybar
echo -e "${RED}[i] done.${NC}"


# ---------------- Chrome ------------

echo ""
echo -e "${RED}[+] Checking if Chrome is installed...${NC}"
echo ""

google-chrome --version
if [ $? != 0 ]
then
  echo ""
  echo -e "${RED}[+] Installing Chrome (deb)...${NC}"
  echo ""
  apt install wget -y
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  apt install -y ./google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
  echo -e "${RED}[i] done.${NC}"
else
  echo ""
  echo -e "${RED}[I] Chrome is already installed.${NC}"
  echo ""
fi

# ----------- Configs ------------
echo ""
echo -e "${RED}[+] Copy configs...${NC}"
echo ""

# copy .config
mkdir -p $USERHOME/.config
cp -r config/* $USERHOME/.config
echo -e "${RED}[i] done.${NC}"

# copy fonts
mkdir -p "/usr/local/share/fonts/"
cp FiraCode/* "/usr/local/share/fonts/"
fc-cache -fv

# copy wallpaper
mkdir -p "/usr/share/backgrounds"
cp bg.jpg "/usr/share/backgrounds"

# ----- END -----

echo ""
echo -e "${RED}[i] All done.${NC}"
