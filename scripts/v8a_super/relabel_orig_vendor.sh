#!/bin/bash
export PATH=/home/poca/aosp/out/host/linux-x86/bin:$PATH
O=/home/poca/mid7021/v8a_build/orig_unpack
SYS="$O/system_a.img"; VEN="$O/vendor_a.img"
echo "=== original super geometry (for faithful rebuild) ==="
(lpdump "$O/../../v8a_a04e/super_sepolicy_raw.img" 2>/dev/null || /home/poca/aosp-rpi3/out/host/linux-x86/bin/lpdump /home/poca/mid7021/v8a_a04e/super_sepolicy_raw.img 2>/dev/null) | grep -iE "Metadata max size|slot|Size of super|block device|Group|Name:|Attributes:|First sector|extents|: [0-9]+ bytes|Partition" | head -40
echo
echo "=== extracted vendor: unlabeled + boringssl present? ==="
debugfs -R "ea_get /bin/boringssl_self_test32 security.selinux" "$VEN" 2>&1 | grep -aoE "u:object_r:[a-z_]+:s0|not found"
debugfs -R "ls /bin" "$VEN" 2>/dev/null | tr " " "\n" | grep -c boringssl
echo
echo "=== build merged file_contexts from THIS userdebug system + THIS vendor ==="
debugfs -R "cat /system/etc/selinux/plat_file_contexts" "$SYS" 2>/dev/null > /tmp/plat_fc2.txt
debugfs -R "cat /etc/selinux/vendor_file_contexts" "$VEN" 2>/dev/null > /tmp/vendor_fc2.txt
cat /tmp/plat_fc2.txt /tmp/vendor_fc2.txt > /tmp/merged_fc2.txt
echo "plat:$(wc -l </tmp/plat_fc2.txt) vendor:$(wc -l </tmp/vendor_fc2.txt) merged:$(wc -l </tmp/merged_fc2.txt) boringssl-in-merged:$(grep -cE "bin/boringssl_self_test\(32" /tmp/merged_fc2.txt)"
echo
echo "=== relabel the EXTRACTED vendor in place ==="
cp "$VEN" "$O/vendor_a_labeled.img"
e2fsdroid -e -S /tmp/merged_fc2.txt -a /vendor "$O/vendor_a_labeled.img" 2>&1 | tail -3
echo "=== verify ==="
for f in /bin/boringssl_self_test32 /bin/boringssl_self_test64 /bin/vndservicemanager /bin/hw; do
  printf "%-32s " "$f"; debugfs -R "ea_get $f security.selinux" "$O/vendor_a_labeled.img" 2>&1 | grep -aoE "u:object_r:[a-z_]+:s0" || echo "UNLABELED"
done
