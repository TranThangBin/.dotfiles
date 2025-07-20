{
  "systemd/user/network-manager-applet.service.d/override.conf".text = ''
    [Service]
    Restart=on-failure
  '';
  "systemd/user/hyprpaper.service.d/override.conf".text = ''
    [Unit]
    Conflicts=mpvpaper.service
  '';
}
