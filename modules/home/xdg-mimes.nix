{ pkgs, lib, ... }:
with lib;
let
  defaultApps = {
    browser  = [ "firefox.desktop" ];
    text     = [ "org.gnome.TextEditor.desktop" ];
    code     = [ "codium.desktop" ];
    markdown = [ "obsidian.desktop" ];
    image    = [ "imv-dir.desktop" ];
    audio    = [ "mpv.desktop" ];
    video    = [ "mpv.desktop" ];
    directory = [ "nemo.desktop" ];
    email    = [ "thunderbird.desktop" ];
    office   = [ "onlyoffice-desktopeditors.desktop" ];
    pdf      = [ "org.gnome.Evince.desktop" ];
    terminal = [ "kitty.desktop" ];
    archive  = [ "org.gnome.FileRoller.desktop" ];
    blender  = [ "blender.desktop" ];
    rdp      = [ "org.remmina.Remmina.desktop" ];
    drawio   = [ "drawio.desktop" ];
    discord  = [ "discord.desktop" ];
  };

  mimeMap = {
    text = [
      "text/plain"
      "text/csv"
      "text/tab-separated-values"
    ];
    code = [
      "text/x-python"
      "text/x-shellscript"
      "text/x-lua"
      "text/x-rust"
      "text/x-java"
      "text/x-csrc"
      "text/x-chdr"
      "text/x-c++src"
      "text/x-c++hdr"
      "text/css"
      "text/xml"
      "application/json"
      "application/javascript"
      "application/x-nix"
    ];
    markdown = [
      "text/markdown"
      "text/x-markdown"
    ];
    image = [
      "image/avif"
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/webp"
    ];
    audio = [
      "audio/aac"
      "audio/flac"
      "audio/mp4"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/wav"
      "audio/webm"
      "audio/x-flac"
      "audio/x-matroska"
    ];
    video = [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/quicktime"
      "video/webm"
      "video/x-flv"
      "video/x-matroska"
      "video/x-ms-wmv"
      "video/x-msvideo"
    ];
    directory = [ "inode/directory" ];
    browser = [
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
    email = [
      "x-scheme-handler/mailto"
      "message/rfc822"
    ];
    office = [
      "application/msword"
      "application/rtf"
      "application/vnd.ms-excel"
      "application/vnd.ms-powerpoint"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.text"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ];
    pdf     = [ "application/pdf" ];
    terminal = [ "terminal" ];
    archive = [
      "application/gzip"
      "application/vnd.rar"
      "application/x-7z-compressed"
      "application/x-bzip2"
      "application/x-compressed-tar"
      "application/x-rar-compressed"
      "application/x-tar"
      "application/x-xz"
      "application/x-zstd"
      "application/zip"
    ];
    blender = [ "application/x-blender" ];
    rdp     = [ "application/x-rdp" ];
    drawio  = [ "application/vnd.jgraph.mxfile" ];
    discord = [ "x-scheme-handler/discord" ];
  };

  associations =
    with lists;
    listToAttrs (
      flatten (
        mapAttrsToList (
          key: map (type: attrsets.nameValuePair type defaultApps."${key}")
        ) mimeMap
      )
    );
in
{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = associations;
  xdg.mimeApps.defaultApplications = associations;

  home.sessionVariables = {
    # prevent wine from creating file associations
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
  };
}
