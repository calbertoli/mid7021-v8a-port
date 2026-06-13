# v8a super build recipe (2026-06-13) — userdebug GSI + relabeled A04e vendor

Builds a bootable v8a super for MID7021 from the proven `super_sepolicy_raw.img`
(userdebug treble GSI + A04e vendor). Boot image = `boot_v8a_seldevelop.img`
(kernel 51e796eb1, SELINUX_DEVELOP=y). Order:

1. **extract_gate.sh** — lpunpack system_a+vendor_a from super_sepolicy_raw.img;
   GATE: confirm system_a is `ro.build.type=userdebug`/`debuggable=1` (treble_arm64_bvS,
   md5 ee24bc58) BEFORE packing — a `*-user` GSI forces enforcing and dies on unlabeled /system.
2. **relabel_orig_vendor.sh** — build merged file_contexts (plat from THIS system + vendor),
   e2fsdroid -S relabel the extracted vendor (fixes boringssl: vendor_boringssl_self_test_exec).
3. **fix_fstab3.py** (run inside build_fstab3.sh) — vendor /etc/fstab.mt6765: keep ONLY system+vendor
   logical (add slotselect); drop product/odm/system_ext phantoms; nofail cache/efs (absent on MID7021,
   ground-truthed via 2nd rooted unit). debugfs -w back, re-relabel (must stay vendor_configs_file).
4. **build_fstab3.sh** — lpmake 2-partition super (system_a + vendor_a, metadata-slots 2,
   group main_a:3299729408, super:3301826560) => super_userdebug_fstab3.img (md5 bbe99f8e).
5. **repack_hung.py** — (diagnostic) repack boot cmdline += hung_task_panic=1 => boot_..._hung.img.

merged_fc2.txt = the merged plat+vendor file_contexts used as the relabel source.
NOTE: fix_fstab.py is the earlier partial transform (kept product/odm) — superseded by fix_fstab3.py.
