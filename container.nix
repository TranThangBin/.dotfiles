{ config, ... }:
{
  home.shellAliases.docker = "${config.services.podman.package}/bin/podman";

  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    PODMAN_COMPOSE_PROVIDER = "${config.lib.packages.podman-compose}/bin/podman-compose";
  };
}
