{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # Floating Rules for Utility and Media
      "float on, match:class ^(Viewnior)$"
      "float on, match:class ^(imv)$"
      "float on, match:class ^(mpv)$"
      "float on, match:class ^(Audacious)$"
      "float on, match:class ^(org.gnome.Calculator)$"
      "float on, match:class ^(org.gnome.FileRoller)$"
      "float on, match:class ^(SoundWireServer)$"
      "float on, match:class ^(.sameboy-wrapped)$"

      # Pinning
      "pin on, match:class ^(rofi)$"
      "pin on, match:class ^(waypaper)$"
      "pin on, match:title ^(Picture-in-Picture)$"

      # Workspace Assignment
      "workspace 5, match:class ^(Spotify)$"
      "workspace 3, match:class ^(discord)$"
      
      # Firefox Sharing Indicator
      "float on, match:title ^(Firefox — Sharing Indicator)$"
      "move 0 0, match:title ^(Firefox — Sharing Indicator)$"
      "float on, match:title ^(Picture-in-Picture)$"
      
      # General Dialogs and Temporary Windows
      "float on, match:class ^(file_progress)$"
      "float on, match:class ^(confirm)$"
      "float on, match:class ^(dialog)$"
      "float on, match:class ^(download)$"
      "float on, match:class ^(notification)$"
      "float on, match:class ^(error)$"
      "float on, match:class ^(confirmreset)$"
      "float on, match:title ^(Open File)$"
      "float on, match:title ^(File Upload)$"
      "float on, match:title ^(branchdialog)$"
      "float on, match:title ^(Confirm to replace files)$"
      "float on, match:title ^(File Operation Progress)$"
      
      # Idle Inhibit & Opacity
      "idle_inhibit focus, match:class ^(mpv)$"
      "idle_inhibit fullscreen, match:class ^(firefox)$"

      # Opacity Override
      "opacity 1.0 override, match:title ^(Picture-in-Picture)$"
      "opacity 1.0 override, match:title ^(.*imv.*)$"
      "opacity 1.0 override, match:title ^(.*mpv.*)$"
      "opacity 1.0 override, match:class ^(Aseprite)$"
      "opacity 1.0 override, match:class ^(Unity)$"
      "opacity 1.0 override, match:class ^(zen)$"
      "opacity 1.0 override, match:class ^(evince)$"
      
      # flameshot multi-display fix
      "move 0 0,match:class (flameshot) match:title (flameshot)"
      "pin on, match:class (flameshot) match:title (flameshot)"
      "fullscreen_state 0, match:class (flameshot) match:title (flameshot)"
      "float on, match:class (flameshot) match:title (flameshot)"

      # blueman
      "float on, match:class ^(.blueman-manager-wrapped)$"
      "center on, match:class ^(.blueman-manager-wrapped)$"
      "size 800 500, match:class ^(.blueman-manager-wrapped)$"

      # IW GTK 
      "float on, match:class ^(org.twosheds.iwgtk)$"
      "center on, match:class ^(org.twosheds.iwgtk)$"
      "size 800 500, match:class ^(org.twosheds.iwgtk)$"
      
      # pavucontrol
      "float on, match:class ^(org.pulseaudio.pavucontrol)$"
      "center on, match:class ^(org.twosheds.iwgtk)$"
      "size 800 500, match:class ^(org.pulseaudio.pavucontrol)$"
      
      # winboat
      "suppress_event maximize fullscreen activate activatefocus, match:class ^(winboat.*|Microsoft Word|Microsoft Outlook|Microsoft Excel|Microsoft PowerPoint|File Explorer|wlfreerdp)$"
      "fullscreen on, match:class ^(winboat.*|Microsoft Word|Microsoft Outlook|Microsoft Excel|Microsoft PowerPoint|File Explorer|wlfreerdp)$"
      "no_initial_focus on, match:class ^(winboat.*|Microsoft Word|Microsoft Outlook|Microsoft Excel|Microsoft PowerPoint|File Explorer|wlfreerdp)$"

      # XWayland Video Bridge
      "opacity 0.0 override, match:class ^(xwaylandvideobridge)$"
      "no_anim on, match:class ^(xwaylandvideobridge)$"
      "no_initial_focus on, match:class ^(xwaylandvideobridge)$"
      "max_size 1 1 on, match:class ^(xwaylandvideobridge)$"
      "no_blur on, match:class ^(xwaylandvideobridge)$"
      
      "force_rgbx on, match:xwayland 1, match:class ^(?!winboat-).+$"
      
      # General Floating Rules
      "center on, match:float true"
      "center on, match:class ^(dialog)$"

      # Remove context menu transparency
      "opaque on, match:class .*, match:title .*" 
      "no_shadow on, match:class .*, match:title .*" 
 #     "no_blur on, match:class .*, match:title .*" 
      
      # No Gaps/Borders for specific full-window workspaces
#      "border_size 0, rounding 0, match:float false, match:workspace w[t1]"
#      "border_size 0, rounding 0, match:float false, match:workspace w[tg1]"
#      "border_size 0, rounding 0, match:float false, match:workspace f[1]"
    ];

    # Workspace-level Gaps Rules
#    workspace = [
#      "w[t1], gapsout:0, gapsin:0"
#      "w[tg1], gapsout:0, gapsin:0"
#      "f[1], gapsout:0, gapsin:0"
#    ];
  };
}
