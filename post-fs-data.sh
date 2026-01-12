#!/system/bin/sh

MODDIR=${0%/*}
SRC="$MODDIR/my_company"
DST="/my_company"

# SRC must be a directory and it must not be empty
[ -d "$SRC" ] || exit 0
[ "$(ls -A "$SRC" 2>/dev/null)" ] || exit 0

# Wait for my_company to be ready
i=0
while ! mountpoint -q /my_company; do
    sleep 0.1
    i=$((i + 1))
    [ "$i" -ge 100 ] && exit 0
done

# Avoid mounting twice
mount | grep -q " on $DST .*bind" && exit 0

# Mount
mount --bind "$SRC" "$DST" || exit 0

# Make it read-only
mount -o remount,ro,bind "$DST" 2>/dev/null

exit 0
