{ config, ... }:
let
  pipewire = config.lib.packages.pipewire;
in
{
  home.file.".asoundrc".source = "${pipewire}/share/alsa/alsa.conf.d/99-pipewire-default.conf";
}
