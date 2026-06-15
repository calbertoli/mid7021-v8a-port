# Build Log — v8a watchdog diagnostic line (v20–v28)

What each image was and what its boot **taught** us. Source for every
`ce92e45b9-dirty` diagnostic is committed as **`0f4d04523`** on branch
`mid7021-wdt-readback` (the `-dirty` tag reflects that the images were built
before that commit). `expdb_vNN` = the breadcrumb-panic dump read off the device.

**Stable reset fingerprint across every bootloop:** `wdt_status 0x2, exp_type 0`
— a silent AP watchdog reset at ~8.18s of kernel uptime.

| Image | md5 | kernel | expdb | Outcome / lesson |
|---|---|---|---|---|
| boot_v5_fullboot.img | 8018e708 | d51438aa5 #7 | — | base v8a boot (A04e ramdisk+cmdline); diagnostics were kernel-swapped onto it |
| boot_wdt-feed.img | a894630c | 82c031685 #9 | v18 | de-neutered "feed-like-stock" WDT — still reset ~8s |
| boot_v8a_ce92e45b9_neuter.img | 69bda094 | ce92e45b9 #1 | — | proven 25.9s-on-v7a neuter kernel onto v8a — bootlooped; proved we had drifted off the proven kernel |
| boot_v8a_wdt_readback.img | fd669cb1 | ce92e45b9 #1 | v20 | **TOPRGU read-back: WDT_MODE 0x7d→0x7c, EN held 0 to 6s → kernel CAN disarm the AP watchdog. Killed the signed-LK dead-end.** |
| boot_v8a_wdt_status79.img | 78d70b21 | ce92e45b9 #2 | v21 | +WDT_STATUS+SPM @7.9s — empty (ioremap-in-atomic-timer bug + 0.28s flush race) |
| boot_v8a_wdt_status70.img | a9ffb765 | ce92e45b9 #3 | v22 | @7.0s — empty (same ioremap bug) |
| boot_v8a_wdt_status65.img | f9998807 | ce92e45b9 #4 | v23 | ioremap fixed; @6.5s: WDT_MODE=0xfc (EN=0, not re-armed by 6.5s), WDT_STATUS=0, SPM_PCM_REG12=0 |
| boot_v8a_pmic_read.img | 62888c60 | ce92e45b9 #5 | v24 | **PMIC TOP_RST_MISC=0x1225 → RG_WDTRSTB_EN(b0)=1 ARMED + WDTRSTB_STATUS(b2)=1 FIRED; after_clr=0x1224 (clearable). WDTRSTB named.** |
| boot_v8a_wdtrstb_kill.img | 323d66ca | ce92e45b9 #6 | — | clear WDTRSTB + panic@12s; superseded by survive before flashing |
| boot_v8a_wdtrstb_survive.img | 2784e2b7 | ce92e45b9 #7 | v25 | **clean negative: PMIC RG_WDTRSTB_EN cleared+held, still bootlooped ~8s → that PMIC bit is NOT the gate (gate is AP-side WDT_MODE_EXRST_EN/b2, never cleared).** |
| boot_v8a_blindspot79.img | 7d07e992 | ce92e45b9 #8 | v26 | blind-spot ring — premature 0.21s panic (jiffies starts ~2^32; bug, owned) |
| boot_v8a_blindspot79b.img | 46971512 | ce92e45b9 #9 (src 0f4d04523) | v27/v28 | jiffies→local_clock fixed. Capture contaminated by A/B-slot fallback (read an un-instrumented kernel). Device finding pending. |
| boot_v8a_rebootcap.img | e1438c10 | ebd409b92 | (pending) | **reboot-capture: hook mtk_wdt_restart()+reboot-notifier → log culprit comm/PID+reason+stack, panic→expdb. Tests SW-reboot/init-suicide hypothesis. Flash BOTH slots + canary.** |
| boot_v8a_rebootcap.img | e1438c10 | ebd409b92 | fable1 | **VERDICT: init suicide. PID1 reboot(RESTART2,"recovery")@6.34s; `security_setenforce(false)`=EINVAL -> init FATAL. NOT a watchdog. Policy loaded OK (audit res=1).** |
| boot_v8a_seldevelop.img | 1d4b4a90 | 51e796eb1 | (pending) | **FIX: CONFIG_SECURITY_SELINUX_DEVELOP=y + BOOTPARAM=y. Lets init setenforce->permissive succeed. Flash boot-only (super already on device), both slots.** |

## Leading hypothesis (open)
TOPRGU re-arms in the unmonitored 6.5→8.18s window (`mtk_wdt_start()` re-sets
`WDT_MODE_EN`, preserving `EXRST_EN`) and fires via EXRST_EN→WDTRSTB→PMIC.
Untested lever: clamp **both** `WDT_MODE_EN` and `WDT_MODE_EXRST_EN` (AP MMIO we control).

## Capture-channel fix (do before next watchdog flash)
Flash the instrumented image to **both** slots (kills A/B fallback) + an early
build-tag/commit **canary** printk, so one console line settles "is this our kernel".

## Banked wins (not in question)
- Kernel controls the AP TOPRGU watchdog → signed-LK dead-end eliminated.
- v8a pipeline runs to ~8s: arm64 kernel → mount GSI+A04e super → switch-root → 2nd-stage init → SELinux policy load (~7s).
- Same kernel reached SurfaceFlinger at 25.9s on the v7a stack → runtime budget to adb exists once the dog is beaten.

## v8a TEE-graft frontier arc (2026-06-14)

Images: `v8a_diagnostics/boot_v8a_pvrbridge900.img` (d1d6372f), `boot_v8a_pvrbridge900_dlptneuter.img` (972ffd14). Run on `super_userdebug_tee_v5` (Trustonic keymaster@4.1 graft + 3 transitive libs + gatekeeper.trustonic + A04e GPL PVR transplant; super untracked, 3.3GB).

Walls cleared this arc (each capture-verified):
- **GPU err311** → A04e GPL m1.13ED5776728 PVR transplant (kernel df4ff38a6, MM bridge 37→46 fn): SurfaceFlinger inits GLES 3.2 on GE8320.
- **gatekeeper hang** (TZTSdaemon wait) → grafted gatekeeper.trustonic.so + `ro.hardware.gatekeeper=trustonic`.
- **keystore2 SQLITE CANTOPEN** → was STALE/corrupt /data (crash-loop residue), NOT a TEE issue; fixed by clean `userdata` erase → formattable reprovisions. On clean /data keystore2 registers (shared-secret OK, km_compat TRUSTED_ENVIRONMENT).
- **~114s false low-battery poweroff** → `dlpt_check_power_off` neuter (kernel b913714a3): boot now runs minutes; apexd-bootstrap activates 5 packages. Battery confirmed **~99%** via KPOC — kernel gauge `soc:0` is garbage from the broken hl7005 charger driver (the real fleet fix, deferred). RUN NEUTER ONLY ON EXTERNAL POWER.

**Current wall (finalstretch11, clean single-boot, valid /data):** `vdc cryptfs init_user0` exits 25 (`EX_SERVICE_SPECIFIC -8`) → init reboots to recovery (`init_user0_failed`) at ~113s, before zygote. Upstream healthy (keymaster+keystore register, /data mounts metadata-encrypted, apexd activates, bootctrl non-fatal). FBE = `inlinecrypt` + raw key (NO wrappedkey_v0); kernel has full inline-crypt + `_FALLBACK`. Leading hypothesis: a non-storage-key keymaster seal/derive op vold needs for user-0 FBE that the grafted Trustonic keymaster handles unlike the GSI expects. Next: decode vdc exit-25 stage + key-dir SELinux labels (offline) → drop-`inlinecrypt` bisection → reserve super-rebuild reboot-suppression capture.
