#!/usr/bin/env bash

init() {

    CURRENT_USERNAME='josi'

    # Colors
    NORMAL=$(tput sgr0)
    WHITE=$(tput setaf 7)
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    BRIGHT=$(tput bold)
    UNDERLINE=$(tput smul)
}

confirm() {
    echo -en "[${GREEN}y${NORMAL}/${RED}n${NORMAL}]: "
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
}

print_header() {
    echo -E "$BLUE
                       ___  _______  _______  ___ 
                      |   ||       ||       ||   |
                      |   ||   _   || ______||   |
                      |   ||  | |  || |_____ |   |
                   ___|   ||  |_|  ||_____  ||   |
                  |       ||       | _____| ||   |
                  |_______||_______||_______||___|
        _  _ _       ___        ___           _        _ _         
       | \| (_)_  __/ _ \ ___  |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
       |  \| | \ \/ / | | / __| | || '_ \/ __| __/ _' | | |/ _ \ '__|
       | |\  | |>  <| |_| \__ \ | || | | \__ \ || (_| | | |\__ \ |   
       |_| \_|_/_/\_\\\___/|___/ |___|_| |_|___/\__\__,_|_|_|\___|_|  


                https://github.com/JoSi-git/nixos-config $RED
      ! To make sure everything runs correctly DONT run as root ! $GREEN
        Inspired by the Frost-Phoenix NixOS configuration. Big shout-out!  $NORMAL
             -> https://github.com/Frost-Phoenix/nixos-config  $NORMAL
    "
}

get_username() {
    echo -en "Enter your$GREEN username$NORMAL : $YELLOW"
    read username
    echo -en "$NORMAL"
    echo -en "Use$YELLOW "$username"$NORMAL as ${GREEN}username${NORMAL} ? "
    confirm
}

set_username() {
    sed -i -e "s/${CURRENT_USERNAME}/${username}/g" ./flake.nix
    sed -i "s|/home/${CURRENT_USERNAME}/|/home/${username}/|g" ./modules/home/rofi/config.rasi
}

get_host() {
    echo -en "Choose a ${GREEN}host${NORMAL} - [${YELLOW}D${NORMAL}]esktop, [${YELLOW}L${NORMAL}]aptop or [${YELLOW}V${NORMAL}]irtual machine: "
    read -n 1 -r
    echo

    if [[ $REPLY =~ ^[Dd]$ ]]; then
        HOST="desktop"
        HOSTNAME="lc-${username}-01"
    elif [[ $REPLY =~ ^[Ll]$ ]]; then
        HOST="latop"
        HOSTNAME="ln-${username}-01"
    elif [[ $REPLY =~ ^[Vv]$ ]]; then
        HOST="vm"
        HOSTNAME="srv-${username}-01"
    else
        echo "Invalid choice. Please select 'D' for desktop, 'L' for laptop or 'V' for virtual machine."
        exit 1
    fi

    echo -en "$NORMAL"
    echo -en "Use the$YELLOW "$HOST"$NORMAL ${GREEN}host${NORMAL} ? "
    confirm
}

install() {
    echo -e "\n${RED}START INSTALL PHASE${NORMAL}\n"

    # Create basic directories
    echo -e "Creating folders:"
    echo -e "    - ${MAGENTA}~/Music${NORMAL}"
    echo -e "    - ${MAGENTA}~/Documents${NORMAL}"
    echo -e "    - ${MAGENTA}~/Pictures/wallpapers/others${NORMAL}"
    echo -e "    - ${MAGENTA}~/Games${NORMAL}"
    mkdir -p ~/Music
    mkdir -p ~/Documents
    mkdir -p ~/Pictures/wallpapers/others
    mkdir -p ~/Games

    # Copy the wallpapers
    echo -e "Copying all ${MAGENTA}wallpapers${NORMAL}"
    cp wallpapers/wallpaper.png ~/Pictures/wallpapers/
    cp -r wallpapers/others/* ~/Pictures/wallpapers/others/

    # User Information
    echo 
    echo -e "${MAGENTA}------------------------------------------------------------------${NORMAL}"
    echo -e "${MAGENTA}POST-INSTALLATION & CONFIGURATION NOTES${NORMAL}"
    echo -e ""
    echo -e "${YELLOW}1. Hardware Configuration:${NORMAL}"
    echo -e "Extended hardware configuration has been automatically deactivated."
    echo -e "To add extra drives or hardware components, check the file hardware.nix uncomment the line in:"
    echo -e "-> ${CYAN}./modules/core/default.nix${NORMAL}"
    echo -e ""
    echo -e "${YELLOW}2. rEFInd Theme (Manual Step):${NORMAL}"
    echo -e "If you want to use the custom rEFInd theme, run this command post Install:"
    echo -e "-> ${CYAN}sudo cp -r /home/${username}/nixos-config/wallpapers/refind/themes /boot/EFI/refind/${NORMAL}"
    echo -e ""
    echo -e "${MAGENTA}------------------------------------------------------------------${NORMAL}\n"

    # Deactivate hardware.nix in the core modules
    sed -i 's|./hardware.nix|# ./hardware.nix|' ./modules/core/default.nix


    # Last Confirmation
    echo -en "You are about to start the system build, do you want to process ? "
    confirm

    # Build the system (flakes + home manager)
    echo -e "\nBuilding the system...\n"
    sudo nixos-rebuild switch --flake .#${HOSTNAME}
}

main() {
    init
    print_header
    get_username
    set_username
    get_host
    install
}

main && exit 0
