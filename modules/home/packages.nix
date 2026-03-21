{ pkgs, ... }:

{
  home.packages = with pkgs; [

    ## CLI Utilities
    bat                   # cat clone with syntax highlighting and Git integration
    duff                  # find duplicate files quickly
    eza                   # ls clone with advanced features
    fd                    # simple, fast and user-friendly alternative to find
    ffmpeg                # audio/video processing tool
    file                  # determine file type
    fzf                   # fuzy finder
    gemini-cli            # google gemini for terminal
    git                   # version control system
    gtrash                # CLI trash utility (safer rm)
    imv                   # Command line media image viewer
    iwgtk                 # Lightweight, graphical wifi management utility for Linux
    micro                 # nano replacement
    mpv                   # Command line media player 
    jq                    # json tool
    lazygit               # git tool
    man-pages             # additional manual pages
    ncdu                  # disk usage analyzer with an ncurses interface
    nitch                 # minimal system fetch tool
    nixd                  # language server for Nix
    nmap                  # network scanner
    openssl               # cryptographic toolkit
    procs                 # modern replacement for ps
    ripgrep               # recursively search directories for a regex pattern
    shfmt                 # shell script formatter
    shellcheck            # shell script static analysis tool
    tldr                  # community-driven man pages
    tree                  # shows folder structure
    zip                   # create compressed files
    unzip                 # extract compressed files
    wget                  # network downloader
    xdg-utils             # desktop integration utilities
    yq                    # YAML processor (like jq for YAML)

    ## Media & Sound CLI
    pamixer               # command-line mixer for PulseAudio
    playerctl             # command-line controller for media players
    tdf                   # terminal PDF viewer
    wavemon               # wireless device monitoring tool
    wl-clipboard          # Wayland clipboard utilities (wl-copy, wl-paste)
    yt-dlp-light          # command-line video downloader

    ## Fun Tools & Terminal Games
#    cbonsai               # grow a bonsai tree in your terminal
    cmatrix               # Matrix-style terminal screensaver
    cowsay                # configurable talking cow (and other creatures)
    fortune               # display a random epigram
    # moon-buggy            # drive a buggy across the moon's surface
    ninvaders             # Space Invaders clone for the terminal
    nsnake                # classic snake game
    nudoku                # Sudoku game for the terminal
    nyancat               # animated Nyan Cat in your terminal
    sl                    # steam locomotive runs across your terminal when you type 'sl' instead of 'ls'
    tty-clock             # digital clock for the terminal
    ttyper                # typing speed test in the terminal
    
    # Lazy Tools
    lazygit
    lazydocker
    
    ## GUI Applications
    audacity              # audio software
    blender               # 3D creation suite
    drawio                # digramm softwarer
    ferdium               # All your services in one place
    github-desktop        # graphical git client for github
    gnome-calculator      # calculator applicationk management utility
    onlyoffice-desktopeditors #
    mission-center        # system resource monitor
    obsidian              # note-tyaking and knowledge management app
    openconnect           # sslvpn client
    paleta                # color pallate generator
    pavucontrol           # PulseAudio volume control GUI
    pitivi                # video editor
    remmina               # remote client
    thonny                # python IDE
    thunderbird           # e-mail client
    vscodium              # IDE
    vlc                   # media player
    discord               # temporary workaround while nixcord is broken
    teamspeak6-client     # discord alternatives
    zenity                # gtk based message windows
  ];
}
