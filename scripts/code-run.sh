#!/usr/bin/env bash

MKTEMP_BIN="$1"
GCC_BIN="$2"
GPP_BIN="$3"
GO_BIN="$4"
PYTHON_BIN="$5"
RM_BIN="$6"

lang=
source=
in=
out=

shift 6

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
tempfile=$($MKTEMP_BIN)

case "$lang" in
c)
    tool="$GCC_BIN"
    compileCmd="$tool -o \"$tempfile\" \"$source\""
    ;;
cpp)
    tool="$GPP_BIN"
    compileCmd="$tool -o \"$tempfile\" \"$source\""
    ;;
go)
    tool="$GO_BIN"
    compileCmd="$tool build -o \"$tempfile\" \"$source\""
    ;;
py)
    tool="$PYTHON_BIN"
    execCmd="$tool $source"
    ;;
*)
    echo "ERROR: $lang is not supported" && "$RM_BIN" "$tempfile" && exit 1
    ;;
esac

command -v "$tool" >/dev/null && echo "ERROR: $tool is not in PATH" && "$RM_BIN" "$tempfile" && exit 1

if [[ -n "$compileCmd" ]] && eval "$compileCmd"; then
    execCmd="$tempfile"
else
    "$RM_BIN" "$tempfile" && exit 1
fi

if [[ -n "$execCmd" ]]; then
    [[ -n "$in" ]] && execCmd="$execCmd <\"$in\""
    [[ -n "$out" ]] && execCmd="$execCmd > $out"
    eval "$execCmd"
fi

"$RM_BIN" "$tempfile"
