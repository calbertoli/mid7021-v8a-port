#!/bin/bash
# Host-side USB/adb enumeration watcher for the v8a neuter boot test.
# Distinguishes: resets@~8s (MTK 0e8d Preloader/BROM re-appears) vs survives (adb 18d1 / stays quiet).
OUT="/home/poca/mid7021/v8a_a04e/neuter_boot_$(date +%H%M%S).log"
echo "watching -> $OUT  (Ctrl-C to stop)"
START=$(date +%s.%N)
while true; do
  T=$(echo "$(date +%s.%N) - $START" | bc)
  U=$(lsusb | grep -iE "0e8d|18d1|mediatek|google" | tr "\n" "|")
  A=$(adb devices 2>/dev/null | grep -w device | awk "{print \$1}" | tr "\n" " ")
  printf "[%7.2f] usb={%s} adb={%s}\n" "$T" "$U" "$A" | tee -a "$OUT"
  if [ -n "$A" ]; then
    echo "=== ADB UP at +${T}s -> grabbing state ===" | tee -a "$OUT"
    adb shell 'getprop sys.boot_completed; getprop init.svc.surfaceflinger; getprop init.svc.adbd; uptime; echo ---DMESG---; dmesg | tail -120; echo ---LOGCAT---; logcat -d -t 150; echo ---PS---; ps -A | wc -l' >> "$OUT" 2>&1
  fi
  sleep 0.5
done
