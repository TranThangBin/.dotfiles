{
  description = "Trant's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:nix-community/nixGL";
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };
    yazi-yatline = {
      url = "github:imsi32/yatline.yazi";
      flake = false;
    };
    yazi-yatline-catppuccin = {
      url = "github:imsi32/yatline-catppuccin.yazi";
      flake = false;
    };
    yazi-relative-motions = {
      url = "github:dedukun/relative-motions.yazi";
      flake = false;
    };
    nvim-plainline = {
      url = "github:eduardo-antunes/plainline";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nur,
      nixgl,
      yazi-plugins,
      yazi-flavors,
      yazi-yatline,
      yazi-yatline-catppuccin,
      yazi-relative-motions,
      nvim-plainline,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      nurPkgs = import nur {
        inherit pkgs;
        nurpkgs = pkgs;
      };

      yaziPlugins = yazi-plugins.outPath;

      yaziFlavors = yazi-flavors.outPath;

      yaziYatline = yazi-yatline.outPath;

      yaziYatlineCatppuccin = yazi-yatline-catppuccin.outPath;

      yaziRelativeMotion = yazi-relative-motions.outPath;

      nvimPlainline = nvim-plainline.outPath;
    in
    {
      homeConfigurations.trant = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit
            pkgsUnstable
            nurPkgs
            yaziPlugins
            yaziFlavors
            nixgl
            yaziYatline
            yaziYatlineCatppuccin
            yaziRelativeMotion
            nvimPlainline
            ;
        };
      };
    };
}
