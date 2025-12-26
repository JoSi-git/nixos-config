{ pkgs, ... }: {
  home.packages = [
    (pkgs.modrinth-app.overrideAttrs (oldAttrs: {
      buildCommand =
        ''
          gappsWrapperArgs+=(
              --set GSK_RENDERER gl
              --set WEBKIT_DISABLE_DMABUF_RENDERER 0
              --set GDK_BACKEND x11
              --set WEBKIT_DISABLE_COMPOSITING_MODE 1 
          )
        ''
        + oldAttrs.buildCommand;
    }))
  ];
}

# Additional parameters:

