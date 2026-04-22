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

download_assets() {
    # Format: "URL|filename"
    local -a ASSETS=(
        "https://media.tenor.com/V4A7awXmANMAAAAj/frog-snail.gif|frog-snail.gif"
    )

    local ASSETS_DIR="./modules/home/quickshell/config/Bar/assets"

    echo -e "\n${YELLOW}DOWNLOADING ASSETS${NORMAL}\n"
    
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────┐${NORMAL}"
    echo -e "${CYAN}│${NORMAL}                     IMPORTANT NOTICE                        ${CYAN}│${NORMAL}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────────┤${NORMAL}"
    echo -e "${CYAN}│${NORMAL}  This script will download images and GIFs from their       ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}  original sources directly to your local machine.           ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}                                                             ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}  These assets are NOT included in this repository           ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}  to avoid distributing potentially copyrighted material.    ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}                                                             ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}  Downloads are intended for private use only.               ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}  By continuing, you confirm that:                           ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}   ✓ You will use these assets for personal use only         ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}   ✓ You understand the author takes no responsibility       ${CYAN}│${NORMAL}"
    echo -e "${CYAN}│${NORMAL}     for any copyright issues in your jurisdiction           ${CYAN}│${NORMAL}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────┘${NORMAL}"
    echo
    echo -e "  ${MAGENTA}A special thanks to all the original artists and creators${NORMAL}"
    echo -e "  ${MAGENTA}whose work makes this setup a little more alive. ${NORMAL}"
    echo
    echo -en "Do you want to download the assets? "
    confirm

    mkdir -p "${ASSETS_DIR}"
    echo -e "\n${BLUE}Downloading assets...${NORMAL}\n"

    local success=0
    local failed=0

    for entry in "${ASSETS[@]}"; do
        local url="${entry%%|*}"
        local filename="${entry##*|}"

        echo -en "  Downloading ${MAGENTA}${filename}${NORMAL}... "
        if curl -fsSL "${url}" -o "${ASSETS_DIR}/${filename}"; then
            echo -e "${GREEN}✓${NORMAL}"
            ((success++))
        else
            echo -e "${RED}✗ Failed${NORMAL}"
            ((failed++))
        fi
    done

    echo
    echo -e "  ${GREEN}✓ ${success} downloaded${NORMAL}, ${RED}✗ ${failed} failed${NORMAL}"
    echo -e "\n${GREEN}Done.${NORMAL}\n"
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
    echo -e "${MAGENTA}┌─────────────────────────────────────────────────────────────┐${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}            POST-INSTALLATION & CONFIGURATION NOTES          ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}├─────────────────────────────────────────────────────────────┤${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}  1. Hardware Configuration:                                 ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}  Extended hardware configuration has been deactivated.      ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}  To add extra drives or hardware components, uncomment:     ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}  -> ./modules/core/default.nix                              ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}                                                             ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}  2. rEFInd Theme (Manual Step):                             ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}  If you want the custom rEFInd theme, run post-install:     ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}  -> sudo cp -r ~/nixos-config/wallpapers/refind/themes      ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}│${NORMAL}     /boot/EFI/refind/                                       ${MAGENTA}│${NORMAL}"
    echo -e "${MAGENTA}└─────────────────────────────────────────────────────────────┘${NORMAL}"
    echo

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
    download_assets
    get_username
    set_username
    get_host
    install
}

main && exit 0
