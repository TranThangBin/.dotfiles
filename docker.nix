let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  home.packages = with pkgsUnstable; [
    docker
    docker-buildx
    lazydocker
    fuse-overlayfs
  ];

  xdg.configFile."docker/daemon.json".text = ''
    {
        "dns": ["8.8.8.8", "8.8.4.4", "1.1.1.1"],
        "dns-search": ["local"]
    }
  '';

  systemd.user.services.docker.Service.ExecStart = "${pkgsUnstable.docker}/bin/dockerd-rootless";
}
