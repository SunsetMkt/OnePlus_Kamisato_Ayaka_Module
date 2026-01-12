#!/system/bin/sh

MODDIR=${0%/*}
SRC="$MODDIR/my_company"
DST="/my_company"

# SRC must exist and not be empty
[ -d "$SRC" ] || exit 0
[ "$(ls -A "$SRC" 2>/dev/null)" ] || exit 0

# Wait for my_company to be mounted (max ~10s)
i=0
while ! mountpoint -q "$DST"; do
    sleep 0.1
    i=$((i + 1))
    [ "$i" -ge 100 ] && exit 0
done

# Avoid mounting twice
mount | grep -q " on $DST .*bind" && exit 0

# Bind mount
mount --bind "$SRC" "$DST" || exit 0

# Keep read-only semantics
mount -o remount,ro,bind "$DST" 2>/dev/null

exit 0
