let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  home.packages = with pkgsUnstable; [
    pipewire
    wireplumber
    pwvucontrol
    helvum
    tree
    alsa-utils
    alsa-firmware
    alsa-tools
    alsa-lib
    alsa-plugins
    openal
  ];

  home.file.".asoundrc".source =
    "${pkgsUnstable.pipewire}/share/alsa/alsa.conf.d/99-pipewire-default.conf";

  services.easyeffects.enable = true;
  services.easyeffects.package = pkgsUnstable.easyeffects;

  systemd.user = with pkgsUnstable; {
    sockets = {
      pipewire = {
        Unit = {
          Description = "PipeWire Multimedia System Sockets";
          ConditionUser = "!root";
        };

        Socket = {
          Priority = 6;
          ListenStream = [
            "%t/pipewire-0"
            "%t/pipewire-0-manager"
          ];
        };

        Install.WantedBy = [ "sockets.target" ];
      };

      pipewire-pulse = {
        Unit = {
          Description = "PipeWire PulseAudio";
          ConditionUser = "!root";
          Conflicts = "pulseaudio.socket";
        };

        Socket = {
          Priority = 6;
          ListenStream = "%t/pulse/native";
        };

        Install.WantedBy = [ "sockets.target" ];
      };
    };

    services = {
      filter-chain = {
        Unit = {
          Description = "PipeWire filter chain daemon";
          After = [
            "pipewire.service"
            "pipewire-session-manager.service"
          ];
          BindsTo = "pipewire.service";
        };
        Service = {
          LockPersonality = "yes";
          MemoryDenyWriteExecute = "yes";
          NoNewPrivileges = "yes";
          RestrictNamespaces = "yes";
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          Type = "simple";
          ExecStart = "${pipewire}/bin/pipewire -c ${pipewire}/share/pipewire/filter-chain.conf";
          Restart = "on-failure";
          Slice = "session.slice";
        };
        Install = {
          Also = "pipewire.socket";
          WantedBy = [ "default.target" ];
        };
      };

      pipewire = {
        Unit = {
          Description = "PipeWire Multimedia Service";
          Requires = "pipewire.socket";
          ConditionUser = "!root";
        };

        Service = {
          LockPersonality = "yes";
          MemoryDenyWriteExecute = "yes";
          NoNewPrivileges = "yes";
          RestrictNamespaces = "yes";
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          Type = "simple";
          ExecStart = "${pipewire}/bin/pipewire -c ${pipewire}/share/pipewire/pipewire.conf";
          Restart = "on-failure";
          Slice = "session.slice";
        };

        Install = {
          Also = "pipewire.socket";
          WantedBy = [ "default.target" ];
        };
      };

      pipewire-pulse = {
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStart = "${pipewire}/bin/pipewire-pulse -c ${pipewire}/share/pipewire/pipewire-pulse.conf";
        };
      };

      wireplumber = {
        Unit = {
          Description = "Multimedia Service Session Manager";
          After = "pipewire.service";
          BindsTo = "pipewire.service";
          Conflicts = "pipewire-media-session.service";
        };

        Service = {
          LockPersonality = "yes";
          MemoryDenyWriteExecute = "yes";
          NoNewPrivileges = "yes";
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          Type = "simple";
          ExecStart = "${wireplumber}/bin/wireplumber -c ${wireplumber}/share/wireplumber/wireplumber.conf";
          Restart = "on-failure";
          Slice = "session.slice";
          Environment = "GIO_USE_VFS=local";
        };

        Install = {
          WantedBy = [ "pipewire.service" ];
          Alias = "pipewire-session-manager.service";
        };
      };
    };
  };
}
