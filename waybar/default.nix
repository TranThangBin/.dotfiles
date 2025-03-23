{ pkgs, ... }:
{
  imports = [ ./config.nix ];

  xdg.configFile."waybar/style.css".source = "${./style.css}";
}
