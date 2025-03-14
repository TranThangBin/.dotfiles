let
  USERNAME = builtins.getEnv "USER";
  nur-no-pkgs =
    import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz")
      { };
in
{
  programs.firefox = {
    enable = true;
    profiles."${USERNAME}" = {
      name = USERNAME;
      isDefault = true;
      extensions = {
        packages = with nur-no-pkgs.repos.rycee.firefox-addons; [
          ublock-origin
          vimium
          darkreader
        ];
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "";
        "font.name.serif.x-western" = "FiraCode  Nerd Font Propo";
        "font.name.sans-serif.x-western" = "FiraCode  Nerd Font Propo";
        "font.name.monospace.x-western" = "FiraCode  Nerd Font Mono";
        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        "browser.newtabpage.enabled" = false;
      };
    };
  };
}
