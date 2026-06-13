#!/bin/bash
export PATH=/home/poca/aosp/out/host/linux-x86/bin:$PATH
O=/home/poca/mid7021/v8a_build/orig_unpack
SYS="$O/system_a.img"; VEN="$O/vendor_a_labeled.img"
SS=$(stat -c%s "$SYS"); VS=$(stat -c%s "$VEN")
echo "system_a=$SS  vendor_a_labeled=$VS  (sum=$((SS+VS)) <= 3299729408)"
OUT=/home/poca/mid7021/v8a_a04e/super_userdebug_relabel.img
rm -f "$OUT"
lpmake --metadata-size 65536 --metadata-slots 2 --device super:3301826560 --group main_a:3299729408 \
  --partition system_a:readonly:$SS:main_a --image system_a="$SYS" \
  --partition vendor_a:readonly:$VS:main_a --image vendor_a="$VEN" \
  --output "$OUT"
echo "lpmake rc=$? size=$(stat -c%s "$OUT" 2>/dev/null)"
echo "staged md5: $(md5sum "$OUT" | cut -c1-32)"
