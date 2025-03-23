{ config, ... }:
{
  imports = [ ./config.nix ];

  xdg.desktopEntries.FirefoxSocials = {
    type = "Application";
    name = "Firefox (Socials)";
    exec = "${config.programs.firefox.package}/bin/firefox messenger.com chat.zalo.me";
  };
}
