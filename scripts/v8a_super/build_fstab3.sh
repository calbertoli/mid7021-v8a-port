#!/bin/bash
export PATH=/home/poca/aosp/out/host/linux-x86/bin:$PATH
O=/home/poca/mid7021/v8a_build/orig_unpack
SRC="$O/vendor_a_labeled.img"; DST="$O/vendor_a_fstab3.img"
debugfs -R "cat /etc/fstab.mt6765" "$SRC" 2>/dev/null > /tmp/fstab.orig
python3 /tmp/fix_fstab3.py
echo "=== logical entries remaining (must be ONLY system+vendor) ==="
grep -vE "^#|^$" /tmp/fstab.new | awk "{if(\$1!~/^\//)print \$1}"
echo "=== cache/efs nofail? data/metadata untouched? ==="
grep -E "/cache|/mnt/vendor/efs|/data |/metadata " /tmp/fstab.new | awk "{print \$2, \$3, \$5}"
cp "$SRC" "$DST"
debugfs -w -R "rm /etc/fstab.mt6765" "$DST" 2>/dev/null
debugfs -w -R "write /tmp/fstab.new /etc/fstab.mt6765" "$DST" 2>/dev/null
debugfs -w -R "sif /etc/fstab.mt6765 mode 0100644" "$DST" 2>/dev/null
e2fsdroid -e -S /tmp/merged_fc2.txt -a /vendor "$DST" 2>&1 | tail -1
echo "=== label check ==="; debugfs -R "ea_get /etc/fstab.mt6765 security.selinux" "$DST" 2>&1 | grep -aoE "u:object_r:[a-z_]+:s0|not found"
SYS="$O/system_a.img"; SS=$(stat -c%s "$SYS"); VS=$(stat -c%s "$DST")
OUT=/home/poca/mid7021/v8a_a04e/super_userdebug_fstab3.img; rm -f "$OUT"
lpmake --metadata-size 65536 --metadata-slots 2 --device super:3301826560 --group main_a:3299729408 \
  --partition system_a:readonly:$SS:main_a --image system_a="$SYS" \
  --partition vendor_a:readonly:$VS:main_a --image vendor_a="$DST" --output "$OUT" 2>/dev/null
echo "lpmake rc=$? size=$(stat -c%s "$OUT" 2>/dev/null) md5=$(md5sum "$OUT"|cut -c1-32)"
