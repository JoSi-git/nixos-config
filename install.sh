#!/usr/bin/env bash

init() {
    CURRENT_USERNAME='josi'
}

confirm() {
    echo -n "[y/n]: "
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
}

print_header() {
cat << 'EOF'
      _       _____ _   _        _   _ _       ____   _____    _____           _        _ _           
     | |     / ____(_) ( )      | \ | (_)     / __ \ / ____|  |_   _|         | |      | | |          
     | | ___| (___  _  |/ ___   |  \| |___  _| |  | | (___      | |  _ __  ___| |_ __ _| | | ___ _ __ 
 _   | |/ _ \\___ \| |   / __|  | . ` | \ \/ / |  | |\___ \     | | | '_ \/ __| __/ _` | | |/ _ \ '__|
| |__| | (_) |___) | |   \__ \  | |\  | |>  <| |__| |____) |   _| |_| | | \__ \ || (_| | | |  __/ |   
 \____/ \___/_____/|_|   |___/  |_| \_|_/_/\_\\____/|_____/   |_____|_| |_|___/\__\__,_|_|_|\___|_|   
                                                                                                     
EOF
}

get_username() {
    echo -n "Enter desired username [josi]: "
    read input_username
    username="${input_username:-josi}"
    
    echo -n "Use \"$username\" as username? "
    confirm
}

create_user() {
    if id "$username" &>/dev/null; then
        echo "User \"$username\" already exists, skipping creation."
    else
        echo "Creating user \"$username\"..."
        sudo useradd -m -s /bin/bash "$username"
        echo "Set password for $username:"
        sudo passwd "$username"
        sudo usermod -aG wheel,audio,video,network,users "$username"
    fi
}

set_username() {
    echo "Replacing username in configuration files..."
    sed -i "s/josi/${username}/g" ./flake.nix
    sed -i "s/josi/${username}/g" ./modules/home/audacious.nix
}

get_host() {
    echo -n "Choose a host type - [D]esktop, [L]aptop, [V]irtual machine: "
    read -n 1 -r
    echo

    if [[ $REPLY =~ ^[Dd]$ ]]; then
        HOST='desktop'
    elif [[ $REPLY =~ ^[Ll]$ ]]; then
        HOST='laptop'
    elif [[ $REPLY =~ ^[Vv]$ ]]; then
        HOST='vm'
    else
        echo "Invalid selection."
        exit 1
    fi

    echo -n "Use \"$HOST\" as host type? "
    confirm
}

install() {
    echo
    echo "=== START INSTALLATION ==="
    echo

    echo "Creating folders in ~/$username"
    sudo -u "$username" mkdir -p /home/"$username"/{Music,Documents,Pictures/wallpapers/others}

    echo "Copying wallpapers..."
    sudo -u "$username" cp -r wallpapers/wallpaper.png /home/"$username"/Pictures/wallpapers/
    sudo -u "$username" cp -r wallpapers/others/* /home/"$username"/Pictures/wallpapers/others/

    echo "Copying hardware configuration to hosts/${HOST}/"
    sudo cp /etc/nixos/hardware-configuration.nix hosts/${HOST}/hardware-configuration.nix

    echo -n "Proceed with system build? "
    confirm

    echo "Running nixos-rebuild switch..."
    sudo nixos-rebuild switch --flake .#${HOST}
}

main() {
    init
    print_header
    get_username
    create_user
    set_username
    get_host
    install
}

main && exit 0
