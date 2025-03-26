{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pwvucontrol
    helvum
    alsa-utils
    alsa-firmware
    alsa-tools
    alsa-lib
  ];

  systemd.user.services = with pkgs; {
    pipewire = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pipewire}/bin/pipewire";
      };
    };

    pipewire-pulse = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pipewire}/bin/pipewire-pulse";
      };
    };

    wireplumber = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${wireplumber}/bin/wireplumber";
        Restart = "always";
      };
    };
  };
}
