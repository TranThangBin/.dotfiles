{
  imports = [ ./config.nix ];

  xdg.configFile.nvim.source = "${./.}";
}
