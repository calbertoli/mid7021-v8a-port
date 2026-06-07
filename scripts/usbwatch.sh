#!/bin/bash
OUT=/home/poca/mid7021/usbwatch.log
: > "$OUT"
echo "[usb] baseline $(date +%H:%M:%S):" >> "$OUT"
lsusb >> "$OUT" 2>&1
echo "[usb] --- monitoring bus events (udevadm) + lsusb diffs ---" >> "$OUT"
# event-driven USB add/remove with timestamps (no sudo needed)
( stdbuf -oL udevadm monitor --udev --subsystem-match=usb 2>/dev/null | while IFS= read -r line; do echo "$(date +%H:%M:%S.%3N) $line"; done ) >> "$OUT" 2>&1 &
UMON=$!
prev="$(lsusb)"
end=$(( $(date +%s) + 360 ))
while [ $(date +%s) -lt $end ]; do
  cur="$(lsusb)"
  if [ "$cur" != "$prev" ]; then
    echo "[usb] $(date +%H:%M:%S.%3N) LSUSB CHANGED:" >> "$OUT"
    diff <(echo "$prev") <(echo "$cur") | grep "^[<>]" >> "$OUT"
    prev="$cur"
  fi
  sleep 0.25
done
kill $UMON 2>/dev/null
echo "[usb] done $(date +%H:%M:%S)" >> "$OUT"
