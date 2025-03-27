{ pkgs, ... }:
{
  home.packages = with pkgs; [
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

  systemd.user.services.docker.Service.ExecStart = "${pkgs.docker}/bin/dockerd-rootless";
}
