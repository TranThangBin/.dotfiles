{
  xdg-desktop-portal,
  waylandSystemdTarget,
  xdg-desktop-portal-hyprland,
  xdg-desktop-portal-termfilechooser,
}:
{
  services = {
    xdg-desktop-portal = {
      Unit = {
        Description = "Portal service";
        PartOf = "graphical-session.target";
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.portal.Desktop";
        ExecStart = "${xdg-desktop-portal}/libexec/xdg-desktop-portal -v";
        Slice = "session.slice";
      };

      Install.WantedBy = [ "xdg-desktop-autostart.target" ];
    };

    xdg-desktop-portal-hyprland = {
      Unit = {
        Description = "Portal service (Hyprland implementation)";
        PartOf = waylandSystemdTarget;
        After = waylandSystemdTarget;
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.impl.portal.desktop.hyprland";
        ExecStart = "${xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland -v";
        Restart = "on-failure";
        Slice = "session.slice";
      };

      Install.WantedBy = [ "wayland-session-xdg-autostart@hyprland.target" ];
    };

    xdg-desktop-portal-termfilechooser = {
      Unit = {
        Description = "Portal service (terminal file chooser implementation)";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.impl.portal.desktop.termfilechooser";
        ExecStart = "${xdg-desktop-portal-termfilechooser}/libexec/xdg-desktop-portal-termfilechooser -l TRACE -c ${xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/config";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "xdg-desktop-autostart.target" ];
    };
  };
}
