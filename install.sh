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


               $CYAN https://github.com/JoSi-git/nixos-config $RED
      ! To make sure everything runs correctly DONT run as root ! $GREEN
                       -> '\"./install.sh\"' $NORMAL
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
}

get_host() {
    echo -en "Choose a ${GREEN}host${NORMAL} - [${YELLOW}D${NORMAL}]esktop, [${YELLOW}L${NORMAL}]aptop or [${YELLOW}V${NORMAL}]irtual machine: "
    read -n 1 -r
    echo

    if [[ $REPLY =~ ^[Dd]$ ]]; then
        HOST='desktop'
    elif [[ $REPLY =~ ^[Ll]$ ]]; then
        HOST='laptop'
    elif [[ $REPLY =~ ^[Vv]$ ]]; then
        HOST='vm'
    else
        echo "Invalid choice. Please select 'D' for desktop, 'L' for laptop or 'V' for virtual machine."
        exit 1
    fi

    echo -en "$NORMAL"
    echo -en "Use the$YELLOW "$HOST"$NORMAL ${GREEN}host${NORMAL} ? "
    confirm
}

setup_games_partition() {
    local hardware_file="./modules/core/hardware.nix"
    
    echo "WARNING: Currently tested only for Laptops and EXT4 filesystems."
    echo "Do you have a separate partition for games? (y/n)"
    read -r has_games_partition
    
    [[ ! "$has_games_partition" =~ ^[Yy]$ ]] && { echo "Process aborted."; return 0; }
    
    # 1. Display lsblk output for selection
    echo "Available partitions (Name, Size, FSTYPE):"
    local partitions_list
    partitions_list=$(lsblk -lo NAME,SIZE,FSTYPE -nr | grep 'part')
    echo "$partitions_list" | nl -w2 -s') '
    
    echo "Enter the number of the Games partition:"
    read -r selection_number
    
    # Determine Partition Name and Unique ID (UUID)
    local selected_name
    selected_name=$(echo "$partitions_list" | sed -n "${selection_number}p" | awk '{print $1}')

    if [ -z "$selected_name" ]; then 
        echo "Invalid selection."
        return 1
    fi
    
  # Get the UUID
    local selected_uuid
    selected_uuid=$(lsblk -o NAME,UUID -nr | grep "^$selected_name " | awk '{print $2}')
    
    # Nix block template
    local nix_block="fileSystems.\"\/home\/josi\/Games\" = {\n  device = \"UUID=$selected_uuid\";\n  fsType = \"ext4\";\n  options = [ \"defaults\" \"nofail\" \"x-systemd.device-timeout=15s\" ];\n};"

    if grep -q 'fileSystems."/home/josi/Games"' "$hardware_file"; then
        # Replace existing entry
        sed -i "/fileSystems.\"\/home\/josi\/Games\"/,/};/c\
        $nix_block" "$hardware_file"
    else
        # Insert new entry before the final '}'
        sed -i '$i\ \n'"$nix_block" "$hardware_file"
    fi

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
    cp -r wallpapers/wallpaper.png ~/Pictures/wallpapers
    cp -r wallpapers/otherWallpaper/gruvbox/* ~/Pictures/wallpapers/others/
    cp -r wallpapers/otherWallpaper/nixos/* ~/Pictures/wallpapers/others/

    # Get the hardware configuration
    echo -e "Copying ${MAGENTA}/etc/nixos/hardware-configuration.nix${NORMAL} to ${MAGENTA}./hosts/${HOST}/${NORMAL}\n"
    cp /etc/nixos/hardware-configuration.nix hosts/${HOST}/hardware-configuration.nix

    # Last Confirmation
    echo -en "You are about to start the system build, do you want to process ? "
    confirm

    # Build the system (flakes + home manager)
    echo -e "\nBuilding the system...\n"
    sudo nixos-rebuild switch --flake .#${HOST}
}

main() {
    init
    print_header
    get_username
    set_username
    get_host
    setup_games_partition
    install
}

main && exit 0
