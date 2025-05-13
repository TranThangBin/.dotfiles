{ config, pkgs, ... }:
{
  systemd.user.services = {
    xdg-desktop-portal = {
      Unit = {
        Description = "Portal service";
        # PartOf = config.wayland.systemd.target;
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.portal.Desktop";
        ExecStart = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal -v";
        Slice = "session.slice";
      };

      Install.WantedBy = [ "xdg-desktop-autostart.target" ];
    };
    xdg-desktop-portal-hyprland = {
      Unit = {
        Description = "Portal service (Hyprland implementation)";
        # PartOf = config.wayland.systemd.target;
        After = config.wayland.systemd.target;
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.impl.portal.desktop.hyprland";
        ExecStart = "${config.wayland.windowManager.hyprland.finalPortalPackage}/libexec/xdg-desktop-portal-hyprland";
        Restart = "on-failure";
        Slice = "session.slice";
      };

      Install.WantedBy = [ "xdg-desktop-autostart.target" ];
    };
  };
}
