#!/usr/bin/env bash

MKTEMP_BIN="$1"
CHMOD_BIN="$2"
SUDO_BIN="$3"
MKDIR_BIN="$4"
MOUNT_CIFS_BIN="$5"
RM_BIN="$6"

address=
mount_point=
username=
password=

read -rp "Enter your address (e.g. //192.168.1.5/share): " address
read -rp "Mount point (e.g. /mnt/share): " mount_point
read -rp "Username: " username

read -rsp "Password: " password
echo

credfile=$("$MKTEMP_BIN")
"$CHMOD_BIN" u=rw,go= "$credfile"
{
    echo "username=$username"
    echo "password=$password"
} >"$credfile"

"$SUDO_BIN" "$MKDIR_BIN" "$mount_point"
"$SUDO_BIN" "$MOUNT_CIFS_BIN" "$address" "$mount_point" -o "credentials=$credfile"

"$SUDO_BIN" -k

"$RM_BIN" "$credfile"
