{
  fastfetch,
  sudoBin,
  mktempBin,
}:
{
  oh-my-zsh.enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  initContent = ''
    [ -z $TMUX ] && ${fastfetch}/bin/fastfetch

    mount-smb() {
        local address mount_point username password

        printf "Enter your address (e.g: //192.168.1.5/share): "
        read -r address

        printf "mount point (e.g: /mnt/share): "
        read -r mount_point

        printf "username: "
        read -r username

        printf "password: "
        read -rs password

        echo

        ${sudoBin} mount -t cifs "$address" "$mount_point" --mkdir -o "username=$username,password=$password"
        ${sudoBin} -k
    }

    code-run() {
        local lang source in out

        for arg in "$@"; do
            case "$arg" in
            --lang=*)
                lang=''${arg#--lang=}
                ;;
            --source=*)
                source=''${arg#--source=}
                ;;
            --in=*)
                in=''${arg#--in=}
                ;;
            --out=*)
                out=''${arg#--out=}
                ;;
            --help)
                echo "INFO: this flag has not been implemented which $0 instead"
                return 0
                ;;
            *)
                echo "WARN: unrecognizable argument $arg"
                ;;
            esac
        done

        if [[ -z "$source" ]]; then
            echo "ERROR: source is not provided"
            return 1
        fi

        if [[ -z "$lang" ]]; then
            lang=''${source##*.}
            [[ -z "$lang" ]] && echo "ERROR: cannot infer lang from $source"
        fi

        local tool compileCmd execCmd
        local tempfile=$(${mktempBin})

        case "$lang" in
            c)
                tool=gcc
                compileCmd="gcc -o \"$tempfile\" \"$source\""
                ;;
            cpp)
                tool=g++
                compileCmd="g++ -o \"$tempfile\" \"$source\""
                ;;
            go)
                tool=go
                compileCmd="go build -o \"$tempfile\" \"$source\""
                ;;
            py)
                tool=python3
                execCmd=python3 $source
                ;;
            *)
                echo "ERROR: $lang is not supported" && rm "$tempfile" && return 1
                ;;
        esac

        command -v "$tool" >/dev/null
        [[ "$?" != 0 ]] && echo "ERROR: $tool is not in PATH" && rm "$tempfile" && return 1

        if [[ -n "$compileCmd" ]] && eval "$compileCmd"; then
            execCmd="$tempfile"
        else
            rm "$tempfile" && return 1
        fi

        if [[ -n "$execCmd" ]]; then
            [[ -n "$in" ]] && execCmd="$execCmd <\"$in\""
            [[ -n "$out" ]] && execCmd="$execCmd > $out"
            eval "$execCmd"
        fi

        rm "$tempfile"
    }
  '';

  history = {
    ignoreAllDups = true;
    ignoreSpace = true;
    ignorePatterns = [
      "clear"
      "sudo *"
    ];
  };

  oh-my-zsh = {
    theme = "robbyrussell";
    plugins = [
      "tmux"
      "vi-mode"
      "systemd"
      "git"
    ];
    extraConfig = ''
      bindkey '^ ' autosuggest-accept
    '';
  };
}
