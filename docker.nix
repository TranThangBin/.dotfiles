let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  home.packages = with pkgsUnstable; [
    docker
    docker-buildx
    lazydocker
    rootlesskit
    fuse-overlayfs
    slirp4netns
  ];

  xdg.configFile."docker/daemon.json".text = ''{ "dns": ["8.8.8.8", "8.8.4.4", "1.1.1.1"] }'';

  systemd.user.services.docker = {
    Unit = {
      Description = "Docker Application Container Engine (Rootless)";
      Documentation = "https://docs.docker.com/go/rootless/";
      Requires = "dbus.socket";
    };

    Service = {
      Environment = "PATH=${builtins.getEnv "PATH"}";
      ExecReload = "/bin/kill -s HUP $MAINPID";
      ExecStart = "${pkgsUnstable.docker}/bin/dockerd-rootless";
      TimeoutSec = "0";
      RestartSec = "2";
      Restart = "always";
      StartLimitBurst = "3";
      StartLimitInterval = "60s";
      LimitNOFILE = "infinity";
      LimitNPROC = "infinity";
      LimitCORE = "infinity";
      TasksMax = "infinity";
      Delegate = "yes";
      Type = "notify";
      NotifyAccess = "all";
      KillMode = "mixed";
    };
  };
}
