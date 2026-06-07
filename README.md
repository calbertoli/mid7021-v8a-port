# MID7021 — 32-bit → 64-bit (v7a → v8a) port: boot-image lab

Working artifacts from an effort to convert the **Onn 100135924 / Lightcomm MID7021** tablet from a 32-bit (`armeabi-v7a`) Android build to a shippable **64-bit (`arm64-v8a`)** ROM.

This repo holds the **boot images, capture logs, SELinux policy work, and scripts**. The kernel **source + full commit history** lives in the companion repo:

➡️ **https://github.com/calbertoli/mid7021-v8a-kernel**

---

## Why

The MID7021 is a low-cost clearance tablet deployed as a nonprofit education fleet (hundreds of units). It ships as 32-bit Android 14, which can no longer run a growing share of 64-bit-only apps. The goal is a **64-bit ROM** that boots reliably on the existing hardware so the fleet stays useful — recoverability and safety are paramount (no touching preloader/secure-boot).

## The device

| | |
|---|---|
| SoC | MediaTek **MT6765** (Helio P35 class), 4× A53 + 4× A53 |
| GPU | **PowerVR GE8320** (DDK 1.13 @ 5776728) |
| Kernel | Linux **4.19.191** (pre-GKI, MTK BSP) |
| Android | 14, build **UP1A.231005.007** |
| Display | **SAT070** panel, 1024×600 landscape (Tinno TPD) |
| Touch | Hynitron **CST226SE** (i2c 0x5a) |
| Camera | GalaxyCore **gc02m1** (main + sub, fixed-focus) |

## Approach

A same-SoC 64-bit port, since a kernel-only swap is insufficient (32-bit userspace can't run 64-bit apps):

1. **arm64 kernel** — built from the Motorola `hawaiipl` (MT6765) tree, with this device's drivers ported in: SAT070 panel, CST226SE touch, gc02m1 camera, plus diagnostics. (See the kernel repo.)
2. **64-bit userspace** — donor vendor + HALs from the **Samsung Galaxy A04e** (an *exact build match*, `UP1A.231005.007`, same MT6765 + GE8320 + DDK), paired with a **TrebleDroid arm64 vanilla GSI** for `/system`.
3. **Hand-built `super`** (`lpmake`, raw) with `system_a` (GSI) + `vendor_a` (A04e), **AVB disabled**, **SELinux permissive** during bring-up.

## Where it got to (honest status)

**On the v7a (32-bit) `super`** — kernel commit `ce92e45b9`, watchdog neutered:
- Boots to **SurfaceFlinger + full HAL stack, 438 processes, ~25.9 s** of kernel uptime.
- Wall: the **PowerVR GPU bridge** — `err 311` from 32-bit `/vendor` GL blobs talking to the 64-bit `pvrsrvkm`. This is exactly what the A04e 64-bit vendor is meant to fix.

**On the v8a (64-bit A04e) `super`:**
- First-stage init mounts `/metadata`, creates + mounts the logical `system_a` (GSI) and `vendor_a` (A04e) partitions, **switches root into the 64-bit GSI**, mounts `/vendor`, and reaches **second-stage init compiling/loading the SELinux policy (~7 s)**.
- Ceiling: a **~8 s reset** attributed to the LK-armed **TOPRGU watchdog**. The neuter that reached 25.9 s on v7a was, for a stretch, *not* carried onto the v8a kernel builds — the latest images put it back to test whether the watchdog was ever the real v8a blocker.

### Open problems
- **GPU bridge (`err 311`)** — the UI gate on the bridge stack; the 64-bit A04e vendor is the intended fix.
- **~8 s watchdog reset** on the v8a stack — under active diagnosis (is the kernel's MMIO to the dog effective, or does it need the proven neuter / userspace feeding?).

## Repo layout

| Path | Contents |
|---|---|
| `boot_images/` | **74 unique** boot images (`arm64_boot_*`, `boot_a04e_v8a_*`, `boot_v8a_*`). See `MANIFEST.md`. |
| `MANIFEST.md` | Every image with size, MD5, and **embedded kernel commit** (diff against the kernel repo). |
| `logs/` | Boot captures — kernel `dmesg` (`*_kmsg.txt`), `logcat`, `getprop`, `ps` from milestone boots; `stock_kconfig.txt`. |
| `sepolicy/` | SELinux work — the `.cil` sources and the compiled `precompiled_sepolicy` + sha256 hashes used to satisfy split-policy on the GSI+A04e mix. |
| `scripts/` | Host-side capture helpers (USB/adb enumeration watchers, etc.). |

## Reading a boot image

Each image is `kernel + ramdisk` (Android boot header v2). Unpack with [`magiskboot`](https://github.com/topjohnwu/Magisk):

```sh
magiskboot unpack boot_v8a_ce92e45b9_neuter.img   # -> kernel, ramdisk.cpio, dtb
```

The kernel's build fingerprint (and thus the source commit) is in `MANIFEST.md`; check out that commit in the kernel repo to see exactly what's inside.

## What's *not* here (and why)

The `super`/`system` images (1–3 GB each) exceed GitHub's 100 MB file limit, and proprietary **stock/donor firmware dumps** (Samsung A04e, the tablet's stock partitions) are deliberately **excluded** for copyright reasons. The kernel is GPLv2 (Motorola-published; see kernel repo). The boot images here contain that GPL kernel plus open ramdisks, shared for research and educational reproducibility.

---

*Community contributions, analysis, and ideas on the GPU bridge and watchdog walls are very welcome.*
