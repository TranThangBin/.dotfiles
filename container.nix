{ config, ... }:
{
  home.shellAliases.docker = "${config.services.podman.package}/bin/podman";

  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    PODMAN_COMPOSE_PROVIDER = "${config.lib.packages.podman-compose}/bin/podman-compose";
  };

  services.podman.settings.containers.network.compose_providers = [
    "${config.lib.packages.podman-compose}/bin/podman-compose"
  ];

  systemd.user = {
    services.podman = {
      Unit = {
        Description = "Podman API Service";
        Requires = "podman.socket";
        After = "podman.socket";
        Documentation = "man:podman-system-service(1)";
        StartLimitIntervalSec = 0;
      };

      Service = {
        Delegate = true;
        Type = "exec";
        KillMode = "process";
        Environment = ''LOGGING="--log-level=info"'';
        ExecStart = "${config.services.podman.package}/bin/podman $LOGGING system service";
      };
    };
    sockets.podman = {
      Unit = {
        Description = "Podman API Socket";
        Documentation = "man:podman-system-service(1)";
      };

      Socket = {
        ListenStream = "%t/podman/podman.sock";
        SocketMode = 660;
      };
    };
  };
}
