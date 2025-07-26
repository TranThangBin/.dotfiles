#!/usr/bin/env bash

lang=
source=
in=
out=

mktemp="$SCRIPT_DIR/dependencies/bin/mktemp"
gcc="$SCRIPT_DIR/dependencies/bin/gcc"
gpp="$SCRIPT_DIR/dependencies/bin/g++"
go="$SCRIPT_DIR/dependencies/bin/go"
python="$SCRIPT_DIR/dependencies/bin/python3"
rm="$SCRIPT_DIR/dependencies/bin/rm"

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
        exit 0
        ;;
    *)
        echo "WARN: unrecognizable argument $arg"
        ;;
    esac
done

if [[ -z "$source" ]]; then
    echo "ERROR: source is not provided"
    exit 1
fi

if [[ -z "$lang" ]]; then
    lang=''${source##*.}
    [[ -z "$lang" ]] && echo "ERROR: cannot infer lang from $source"
fi

tool=
compileCmd=
execCmd=
tempfile=$("$mktemp")

case "$lang" in
c)
    tool="$gcc"
    compileCmd="$tool -o \"$tempfile\" \"$source\""
    ;;
cpp)
    tool="$gpp"
    compileCmd="$tool -o \"$tempfile\" \"$source\""
    ;;
go)
    tool="$go"
    compileCmd="$tool build -o \"$tempfile\" \"$source\""
    ;;
py)
    tool="$python"
    execCmd="$tool $source"
    ;;
*)
    echo "ERROR: $lang is not supported" && "$rm" "$tempfile" && exit 1
    ;;
esac

! command -v "$tool" >/dev/null && echo "ERROR: $tool is not in PATH" && "$rm" "$tempfile" && exit 1

if [[ -n "$compileCmd" ]] && eval "$compileCmd"; then
    execCmd="$tempfile"
else
    "$rm" "$tempfile" && exit 1
fi

if [[ -n "$execCmd" ]]; then
    [[ -n "$in" ]] && execCmd="$execCmd <\"$in\""
    [[ -n "$out" ]] && execCmd="$execCmd > $out"
    eval "$execCmd"
fi

"$rm" "$tempfile"
