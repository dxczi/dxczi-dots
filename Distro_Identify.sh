#!/bin/bash
# Based off https://github.com/JaKooLit
# Script to clone the Distro-Hyprland install # scripts

#######################################
# Set some colors for output messages #
#######################################

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

###################################
# Detect the current distribution #
# using /etc/os-release           #
###################################

if [ -f /etc/os-release ]; then
    . /etc/os-release
    distro_name=$NAME
    distro_version=$VERSION_ID
else
    echo "${ERROR} Unable to detect the distribution. Exiting."
    exit 1
fi

##############################
# Define package managers,   #
# Git install commands, and  #
# dynamic variables for each #
##############################

###########################
#### Arch-based Distro ####
###########################

if command -v pacman &> /dev/null; then
    PACKAGE_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    GIT_INSTALL_CMD="sudo pacman -S git --noconfirm"
    Distro="Arch-Hyprland"
   Github_URL="https://github.com/JaKooLit/$Distro.git"
    Distro_DIR="$HOME/$Distro"

#############################
#### Fedora-based Distro ####
#############################

elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    GIT_INSTALL_CMD="sudo dnf install -y git"
    Distro="Fedora-Hyprland"
    Github_URL="https://github.com/JaKooLit/$Distro.git"
    Distro_DIR="$HOME/$Distro"

####################
#### Nix Distro ####
####################

elif [ "$distro_name" = "NixOS" ]; then
    PACKAGE_MANAGER="nix"
    INSTALL_CMD="nix-shell"
    GIT_INSTALL_CMD="nix-shell -p git curl pciutils"
    Distro="NixOS-Hyprland"
   Github_URL="https://github.com/JaKooLit/$Distro.git"
    Distro_DIR="$HOME/$Distro"
fi

##########################################
# Check for Git and install if not found #
##########################################

if ! command -v git &> /dev/null; then
    echo "${INFO} Git not found! ${SKY_BLUE}Installing Git...${RESET}"
    if ! $GIT_INSTALL_CMD; then
        echo "${ERROR} Failed to install Git. Exiting."
        exit 1
    fi
fi

#########################################
# Check if the directory already exists #
# and then perform clone or update      #
#########################################

if [ -d "$Distro_DIR" ]; then
    echo "${YELLOW}$Distro_DIR exists. Updating the repository... ${RESET}"
    cd "$Distro_DIR"
    git stash && git pull
    chmod +x install.sh
    ./install.sh

else
    echo "${MAGENTA}$Distro_DIR does not exist. Cloning the repository...${RESET}"
    cd "$Distro_DIR"
    chmod +x install.sh
    ./install.sh
fi
