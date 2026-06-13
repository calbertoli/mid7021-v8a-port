#!/bin/bash
export PATH=/home/poca/aosp/out/host/linux-x86/bin:$PATH
SUP=/home/poca/mid7021/v8a_a04e/super_sepolicy_raw.img
OUT=/home/poca/mid7021/v8a_build/orig_unpack
rm -rf "$OUT"; mkdir -p "$OUT"
echo "=== lpunpack the PROVEN fable2 super ==="
lpunpack "$SUP" "$OUT" 2>&1 | tail -3
echo "extracted:"; ls -la "$OUT" | awk "{print \$5, \$9}"
SYS="$OUT/system_a.img"
echo
echo "=== GATE: is the original GSI userdebug? ==="
debugfs -R "cat /system/build.prop" "$SYS" 2>/dev/null | grep -iE "^ro.build.type=|^ro.system.build.type=|^ro.debuggable=|^ro.build.flavor=" | head
echo
echo "=== sanity: is the userdebug GSI system labeled, or unlabeled like the user one? ==="
debugfs -R "ea_get /system/bin/init security.selinux" "$SYS" 2>&1 | grep -aoE "u:object_r:[a-z_]+:s0|not found"
echo
echo "=== pin hashes of all 4 extracted components ==="
md5sum "$OUT"/system_a.img "$OUT"/system_ext_a.img "$OUT"/vendor_a.img "$OUT"/product_a.img 2>/dev/null | sed "s#$OUT/##"
