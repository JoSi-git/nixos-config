{ pkgs, ... }:
{
  home.packages = [
    # nemo-with-extensions bundles nemo-python into nemo's plugin path so it's actually discovered
    (pkgs.nemo-with-extensions.override {
      extensions = with pkgs; [ nemo-python ];
    })
  ];

  # Packet Quick Share plugin — uses Gio.DBusProxy instead of dbus-python (not in nemo's python path)
  home.file.".local/share/nemo-python/extensions/packet_nemo.py".text = ''
    import sys
    import gi
    gi.require_version("GLib", "2.0")
    gi.require_version("Gio", "2.0")
    gi.require_version("GObject", "2.0")
    gi.require_version("Nemo", "3.0")
    from gi.repository import Gio, GLib, GObject, Nemo


    APP_ID = "io.github.nozwock.Packet"


    def send_files(paths):
        try:
            proxy = Gio.DBusProxy.new_for_bus_sync(
                Gio.BusType.SESSION,
                Gio.DBusProxyFlags.NONE,
                None,
                APP_ID,
                f"/{APP_ID.replace('.', '/')}/Share",
                "org.gtk.Actions",
                None,
            )
            proxy.call_sync(
                "Activate",
                GLib.Variant("(sava{sv})", ("send-files", [GLib.Variant("as", paths)], {})),
                Gio.DBusCallFlags.NONE,
                -1,
                None,
            )
        except Exception as e:
            print(f"Packet: {e}", file=sys.stderr)


    class PacketMenuProvider(GObject.GObject, Nemo.MenuProvider):
        def on_activate(self, menu, files):
            send_files([f.get_location().get_path() for f in files])

        def get_file_items(self, window, files):
            if not files or any(f.is_directory() for f in files):
                return []
            item = Nemo.MenuItem(name="PacketMenuProvider::SendFiles", label="Send with Packet", icon="io.github.nozwock.Packet")
            item.connect("activate", self.on_activate, files)
            return [item]

        def get_background_items(self, window, file):
            return []
  '';

  dconf.settings = {
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "kitty";
      exec-arg = "";
    };
    "org/nemo/preferences" = {
      always-use-browser = true;
      close-device-view-on-device-eject = true;
      date-font-choice = "auto-mono";
      date-format = "iso";
      last-server-connect-method = 3;
      quick-renames-with-pause-in-between = true;
      show-edit-icon-toolbar = false;
      show-full-path-titles = false;
      show-hidden-files = true;
      show-home-icon-toolbar = true;
      show-new-folder-icon-toolbar = true;
      show-open-in-terminal-toolbar = true;
      show-search-icon-toolbar = true;
      show-show-thumbnails-toolbar = false;
      thumbnail-limit = 10485760;
    };
    "org/nemo/preferences/menu-config" = {
      background-menu-open-as-root = false;
      selection-menu-open-as-root = false;
      selection-menu-open-in-terminal = false;
      selection-menu-scripts = false;
    };
    "org/nemo/search" = {
      search-reverse-sort = false;
      search-sort-column = "name";
    };
    "org/nemo/window-state" = {
      maximized = true;
      network-expanded = true;
      side-pane-view = "places";
      sidebar-bookmark-breakpoint = 2;
      sidebar-width = 220;
      start-with-sidebar = true;
    };
  };
}
