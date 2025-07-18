{ podman }:
{
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
      ExecStart = "${podman}/bin/podman $LOGGING system service";
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
}
