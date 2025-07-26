#!/usr/bin/env bash

chmod="$SCRIPT_DIR/dependencies/bin/chmod"
mktemp="$SCRIPT_DIR/dependencies/bin/mktemp"
mkdir="$SCRIPT_DIR/dependencies/bin/mkdir"
mount_cifs="$SCRIPT_DIR/dependencies/bin/mount.cifs"
rm="$SCRIPT_DIR/dependencies/bin/rm"

address=
mount_point=
username=
password=

read -rp "Enter your address (e.g. //192.168.1.5/share): " address
read -rp "Mount point (e.g. /mnt/share): " mount_point
read -rp "Username: " username

read -rsp "Password: " password
echo

credfile=$("$mktemp")
"$chmod" u=rw,go= "$credfile"
{
    echo "username=$username"
    echo "password=$password"
} >"$credfile"

sudo "$mkdir" "$mount_point"
sudo "$mount_cifs" "$address" "$mount_point" -o "credentials=$credfile"

sudo -k

"$rm" "$credfile"
