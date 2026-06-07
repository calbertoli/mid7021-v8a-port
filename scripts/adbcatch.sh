#!/bin/bash
OUT=/home/poca/mid7021/v8a_a04e/adbcatch
mkdir -p "$OUT"
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
echo "[catch] watching for adbd (will grab on first appearance)..."
deadline=$(( $(date +%s) + 360 ))   # watch up to 6 minutes
got=0
while [ $(date +%s) -lt $deadline ]; do
  st=$(timeout 2 adb get-state 2>/dev/null)
  if [ "$st" = "device" ] || [ "$st" = "recovery" ]; then
    ts=$(date +%H%M%S)
    echo "[catch] adbd UP state=$st at $ts — grabbing"
    timeout 6 adb shell getprop ro.bootimage.build.fingerprint ro.product.cpu.abi ro.boot.slot_suffix > "$OUT/id_$ts.txt" 2>&1
    timeout 6 adb shell dmesg            > "$OUT/dmesg_$ts.txt" 2>&1
    timeout 6 adb logcat -d              > "$OUT/logcat_$ts.txt" 2>&1
    timeout 6 adb shell ps -A            > "$OUT/ps_$ts.txt" 2>&1
    timeout 6 adb shell dumpsys SurfaceFlinger > "$OUT/sf_$ts.txt" 2>&1
    timeout 6 adb shell getprop          > "$OUT/getprop_$ts.txt" 2>&1
    sz=$(wc -c < "$OUT/logcat_$ts.txt" 2>/dev/null)
    echo "[catch] grabbed; logcat bytes=$sz dmesg bytes=$(wc -c < "$OUT/dmesg_$ts.txt" 2>/dev/null)"
    got=1
    [ "${sz:-0}" -gt 2000 ] && { echo "[catch] substantial logcat captured — stopping"; break; }
  fi
done
echo "[catch] done (got=$got). files in $OUT"
ls -la "$OUT" 2>/dev/null
