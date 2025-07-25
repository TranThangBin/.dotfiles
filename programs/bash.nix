{ uwsm, configHome }:
{
  profileExtra = ''
    start_profile() {
        local answer environment default_id
        [[ "$(tty)" = "/dev/tty1" ]] || return
        ${uwsm}/bin/uwsm check may-start || return
        environment="your wayland environment"
        [[ -f "${configHome}/uwsm/default-id" ]] && read -r default_id < ${configHome}/uwsm/default-id
        [[ -n "$default_id" ]] && environment="''${default_id%.*}"
        read -p "Do you want to start $environment? (Y/n): " -rn 1 answer
        echo
        [[ "$answer" = "Y" ]] && exec ${uwsm}/bin/uwsm start default
        [[ "$answer" = "n" ]] && ${uwsm}/bin/uwsm select && exec ${uwsm}/bin/uwsm start default
    }
    start_profile
  '';
}
