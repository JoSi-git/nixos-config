{ ... }:
{
  wayland.windowManager.hyprland.settings.animations = {
    enabled = true;

    bezier = [
      "wind,          0.05, 0.85, 0.03, 0.97"
      "winIn,         0.07, 0.88, 0.04, 0.99"
      "winOut,        0.20,-0.15, 0,    1"
      "liner,         1,    1,    1,    1"
      "md3_decel,     0.05, 0.80, 0.10, 0.97"
      "md3_accel,     0.20, 0,    0.80, 0.08"
      "easeOutCirc,   0,    0.48, 0.38, 1"
      "menu_decel,    0.05, 0.82, 0,    1"
      "menu_accel,    0.20, 0,    0.82, 0.10"
    ];

    animation = [
      "windowsIn,        1, 2.4, winIn,     slide"
      "windowsOut,       1, 2.1, easeOutCirc"
      "windowsMove,      1, 2.3, wind,      slide"
      "fade,             1, 1.4, md3_decel"
      "layersIn,         1, 1.4, menu_decel, slide"
      "layersOut,        1, 1.2, menu_accel"
      "fadeLayersIn,     1, 1.2, menu_decel"
      "fadeLayersOut,    1, 1.4, menu_accel"
      "border,           1, 1.3, liner"
      "borderangle,      1, 82,  liner, loop"
      "workspaces,       1, 3.0, menu_decel, slide"
      "specialWorkspace, 1, 1.8, md3_decel,  slidefadevert 15%"
    ];
  };
}
