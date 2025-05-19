{ config, pkgs, ... }:
{
  programs.firefox = {
    policies = {
      AppAutoUpdate = false;
      BackgroundAppAutoUpdate = false;
      BlockAboutAddons = false;
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;
      DisableTelemetry = true;
      DisableAppUpdate = true;
      DisableSystemAddonUpdate = true;
      ExtensionUpdate = false;
      Extensions = {
        Install = with pkgs.nur.repos.rycee.firefox-addons; [
          "${ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/uBlock0@raymondhill.net.xpi"
          "${vimium}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{d7742d87-e61d-4b78-b8a1-b469842139fa}.xpi"
          "${darkreader}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/addon@darkreader.org.xpi"
        ];
        Locked = [
          "uBlock0@raymondhill.net"
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}"
          "addon@darkreader.org"
        ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "allowed";
          allowed_types = [ ];
          block_install_message = "uBlock0@raymondhill.net is blocked";
          install_sources = [ ];
          restricted_domains = [ ];
          temporarily_allow_weak_signatures = false;
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          installation_mode = "allowed";
          allowed_types = [ ];
          block_install_message = "{d7742d87-e61d-4b78-b8a1-b469842139fa} is blocked";
          install_sources = [ ];
          restricted_domains = [ ];
          temporarily_allow_weak_signatures = false;
        };
        "addon@darkreader.org" = {
          installation_mode = "allowed";
          allowed_types = [ ];
          block_install_message = "addon@darkreader.org is blocked";
          install_sources = [ ];
          restricted_domains = [ ];
          temporarily_allow_weak_signatures = false;
        };
      };
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      Homepage = {
        URL = "https://itch.io/jams/joined";
        Locked = true;
        StartPage = "homepage-locked";
      };
      ManualAppUpdateOnly = true;
      NewTabPage = true;
      NoDefaultBookmarks = true;
      PromptForDownloadLocation = true;
    };
    profiles."${config.home.username}" = {
      name = config.home.username;
      isDefault = true;
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          vimium
          darkreader
        ];
      };
      settings = {
        "sidebar.verticalTabs" = true;
        "sidebar.visibility" = "hide-sidebar";
        "sidebar.main.tools" = "";
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.tabs.warnOnClose" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "dark-beach";
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper-dark" = "dark-beach";
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper-light" = "dark-beach";
        "browser.uiCustomization.state" = {
          placements = {
            widget-overflow-fixed-list = [ ];
            unified-extensions-area = [
              "addon_darkreader_org-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
            ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "vertical-spacer"
              "urlbar-container"
              "customizableui-special-spring2"
              "downloads-button"
              "alltabs-button"
              "unified-extensions-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            TabsToolbar = [ ];
            vertical-tabs = [ "tabbrowser-tabs" ];
            PersonalToolbar = [
              "import-button"
              "personal-bookmarks"
            ];
          };
          seen = [
            "save-to-pocket-button"
            "developer-button"
            "ublock0_raymondhill_net-browser-action"
            "addon_darkreader_org-browser-action"
            "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
          ];
          dirtyAreaCache = [
            "nav-bar"
            "TabsToolbar"
            "vertical-tabs"
            "unified-extensions-area"
            "PersonalToolbar"
            "toolbar-menubar"
            "widget-overflow-fixed-list"
          ];
          currentVersion = 22;
          newElementCount = 2;
        };
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
}
