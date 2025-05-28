{ config, ... }:
{
  programs.thunderbird.profiles.${config.home.username} = {
    isDefault = true;
  };
}
