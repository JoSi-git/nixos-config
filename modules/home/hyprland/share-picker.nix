{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.hyprland-preview-share-picker.packages.${pkgs.system}.default
  ];

  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
      custom_picker_binary = hyprland-preview-share-picker
    }
  '';

  xdg.configFile."hyprland-preview-share-picker/config.yaml".text = ''
    stylesheets:
      - ./style.css

    windows:
      min_per_row: 3
      max_per_row: 5

    outputs:
      spacing: 4
      respect_output_scaling: false
  '';

  xdg.configFile."hyprland-preview-share-picker/style.css".text = ''
    .window {
      border-radius: 5px;
      border: solid 2px #E2E4E3;
    }

    notebook {
      background-color: @theme_bg_color;
    }

    .page {
      background-color: @theme_bg_color;
      padding: 16px;
    }

    .restore-button {
      background-color: @theme_bg_color;
      border-radius: 0 0 5px 5px;
      padding: 6px 14px;
    }

    .tab-label {
      font-size: 14px;
      font-weight: bold;
      padding: 6px 16px;
    }

    flowboxchild > .card,
    button > .card {
      border-radius: 5px;
    }

    .image {
      border-radius: 3px;
    }
  '';
}
