# Boot Image Manifest

**74 unique boot images** (82 files on disk; 8 were byte-identical copies living in build-work subdirs).

Each image is our arm64 kernel + a ramdisk. The embedded kernel commit is listed so you can diff any image against source in the companion repo: https://github.com/calbertoli/mid7021-v8a-kernel

| Image | Size | Kernel commit | MD5 |
|---|---|---|---|
| `arm64_boot_anchor_logcat.img` | 23MB | `4.19.191-g9657166f9863-dirty` | `355ba77f01eedd838f64fdec7d7ed877` |
| `arm64_boot_cc2.img` | 23MB | `4.19.191-g14940523856c` | `60b7d379a9810113d296792e5e62ae3b` |
| `arm64_boot_cc4.img` | 23MB | `4.19.191-g14940523856c` | `67b8e7d48bf1840823769cecdee97637` |
| `arm64_boot_cclight.img` | 23MB | `4.19.191-g14940523856c` | `8b42c4c49b26ce1780b1847a2dd0987d` |
| `arm64_boot_clean_control.img` | 23MB | `4.19.191-g14940523856c` | `d385eb4ce88528bf8d967f0c8853ab9d` |
| `arm64_boot_diag2.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `e03c455d651ac9a77eef2e84d3d05c11` |
| `arm64_boot_diag.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `838be37487cf98b02f98247eaf8c2aba` |
| `arm64_boot_fbcon.img` | 23MB | `4.19.191-ga951de28f57c` | `1c8ce58b855b8a575fccbaae652c9c0f` |
| `arm64_boot_fnb.img` | 23MB | `4.19.191-gc65cbc1ae7ba` | `16aa9f5df007b575633951892ed93143` |
| `arm64_boot_uart2.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `a9c06d519eef1743bccfc74fa448a087` |
| `arm64_boot_uart3.img` | 22MB | `4.19.191-g16d3e05b6186-dirty` | `7eb0a08334f457cc94bdd6f03c537849` |
| `arm64_boot_uart4.img` | 22MB | `4.19.191-g16d3e05b6186-dirty` | `430f22d757b240ef0fff78f8fbafe1ca` |
| `arm64_boot_uart.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `657908677ffd432a1b80aa21ad9750c3` |
| `arm64_boot_v10.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `a31660ee8049992b6113707bc5df526e` |
| `arm64_boot_v11.img` | 22MB | `4.19.191-g109576c58e42-dirty` | `192c6c7a0516252969583c920b71416c` |
| `arm64_boot_v12.img` | 22MB | `4.19.191-g16d3e05b6186-dirty` | `44b772c66e03903fd5ad8d3abd9bfdc7` |
| `arm64_boot_v13.img` | 22MB | `4.19.191-g16d3e05b6186-dirty` | `f3f26f1cf9eaf4dd439f8d9780b1c942` |
| `arm64_boot_v14.img` | 22MB | `4.19.191-g16d3e05b6186-dirty` | `d47d922739692af14e1a5cd4ec8fd994` |
| `arm64_boot_v15.img` | 22MB | `4.19.191-g16d3e05b6186-dirty` | `9e0243f40bc0220000bb81c263161436` |
| `arm64_boot_v16.img` | 22MB | `4.19.191-g0d542f217557-dirty` | `76798283db582079c98a463fd7620446` |
| `arm64_boot_v17.img` | 22MB | `4.19.191-gc035b82b4f55-dirty` | `0fe87a3ab79281b38c03132258cea3cf` |
| `arm64_boot_v18.img` | 22MB | `4.19.191-gc035b82b4f55-dirty` | `5c8dcf609c55da1ab4a005a7dd21e015` |
| `arm64_boot_v19.img` | 22MB | `4.19.191-ge68e3b553dda-dirty` | `dc7a4e7fede6f38826f6e29366fe388f` |
| `arm64_boot_v20.img` | 22MB | `4.19.191-g330618283e5c-dirty` | `b93a4eb690d308757b32b8a69f9957e3` |
| `arm64_boot_v21_slotA.img` | 22MB | `4.19.191-g1704bef616b2` | `3aa837dc2503fcfa37197f6fb653ef35` |
| `arm64_boot_v22_slotA.img` | 22MB | `4.19.191-g1704bef616b2` | `0373eabf84cf22be382c45bd4c66d894` |
| `arm64_boot_v23_slotA.img` | 22MB | `4.19.191-ga0ee5dd42192` | `7793478061939052120864e766f8c485` |
| `arm64_boot_v24_slotA.img` | 22MB | `4.19.191-ga0ee5dd42192-dirty` | `d15913c5fda8a310b2bfde220e2bd7fd` |
| `arm64_boot_v25_slotA.img` | 22MB | `4.19.191-ga36a7f6afee2-dirty` | `99be1636d5a18fe473cd0557bdc323b5` |
| `arm64_boot_v26_slotA.img` | 22MB | `4.19.191-gfef14d8ce382-dirty` | `2b6a6b805eeee4191ed9133495109d7c` |
| `arm64_boot_v27_magisk.img` | 23MB | `4.19.191-gfef14d8ce382-dirty` | `c9277bbd4ec21f2724e9b09df62e0762` |
| `arm64_boot_v28_clean.img` | 22MB | `4.19.191-g9657166f9863` | `914236fb02b21724077fc59704345830` |
| `arm64_boot_v28_magisk.img` | 23MB | `4.19.191-g9657166f9863` | `4115e2e4d1668cdab3105c11864f1ebb` |
| `arm64_boot_v29_cap.img` | 23MB | `4.19.191-g9657166f9863` | `9ac4b64041be6d566bfe048ee55366bf` |
| `arm64_boot_v29_rc0.img` | 23MB | `4.19.191-g9657166f9863-dirty` | `ce86ca1bd8363ebdcdd1111f332a034f` |
| `arm64_boot_v2.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `3c05c461f201b416bea3430f98cf34c7` |
| `arm64_boot_v30_cap.img` | 23MB | `4.19.191-g9657166f9863` | `83521bf51f3dd314b68a891cf2e33ae9` |
| `arm64_boot_v31_cap.img` | 23MB | `4.19.191-g9657166f9863` | `d2d7928d084233c877dc87e2c9331c3d` |
| `arm64_boot_v32cap.img` | 23MB | `4.19.191-g2c1c0ea6829b` | `514ec02613781bf1d03937b55166385f` |
| `arm64_boot_v32_v2.img` | 23MB | `4.19.191-gc6f78741150a` | `9aa6eb3b16d09526cb910dbd902c27aa` |
| `arm64_boot_v33cap.img` | 23MB | `4.19.191-g2c1c0ea6829b` | `28c811637682d5b2ba1e404b77d8e302` |
| `arm64_boot_v33_v3.img` | 23MB | `4.19.191-ga4cd1f852364` | `cbc7fe1aed5e94e64377e744c94939aa` |
| `arm64_boot_v34cap.img` | 23MB | `4.19.191-g2c1c0ea6829b` | `443706531426c6c6f2d45ae4082ca30b` |
| `arm64_boot_v34_v4.img` | 23MB | `4.19.191-gce92e45b9a05` | `8a07dcca99b5ca9779218e86b113332a` |
| `arm64_boot_v35_clean.img` | 23MB | `4.19.191-gce92e45b9a05-dirty` | `d7934c5dc43292d752f206912ca92765` |
| `arm64_boot_v35_rc0_deferfb.img` | 23MB | `4.19.191-gce92e45b9a05-dirty` | `61fa085fe40bf4bda9e05e0efa61780f` |
| `arm64_boot_v35_rc0.img` | 23MB | `4.19.191-gce92e45b9a05-dirty` | `6be0a000b1190c9875137175e9b87d8d` |
| `arm64_boot_v35_rc0_nofbcon.img` | 23MB | `4.19.191-gce92e45b9a05-dirty` | `4540ef478e5b343b6da921df8c563c84` |
| `arm64_boot_v35_v5.img` | 23MB | `4.19.191-gce92e45b9a05` | `070510c23af3dea193356c6c49e6f8ad` |
| `arm64_boot_v36_v6.img` | 23MB | `4.19.191-gf990ee884278` | `aafeb7ed742524d356b427befb3d30e8` |
| `arm64_boot_v37_v7.img` | 23MB | `4.19.191-g9c56ee34514d` | `5bf6a58d7dcefa70a5cbfc3281f2cf31` |
| `arm64_boot_v38_v7atomic.img` | 23MB | `4.19.191-g9c56ee34514d` | `04adbbbebc5b57275ad5485e0f61e563` |
| `arm64_boot_v3.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `6f9a60cbe4a36f4da01a8fe02a28524c` |
| `arm64_boot_v4.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `929f67f67deb06444ab68f89cd6c865b` |
| `arm64_boot_v5.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `07cec7ea772d22bded5879a0883baead` |
| `arm64_boot_v6.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `07cec7ea772d22bded5879a0883baead` |
| `arm64_boot_v7.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `1c6776ea802ce63871563662d1d95b08` |
| `arm64_boot_v8.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `e8f8bd696fae6363c5667bdf7620ceec` |
| `arm64_boot_v9.img` | 22MB | `4.19.191-g9877fc0407fd-dirty` | `2785ca2d74db81abde31209de4742c0a` |
| `boot_a04e_v8a.img` | 13MB | `4.19.191-gce92e45b9a05-dirty` | `4c1768572ce1be1fe7c26245aae5c4d1` |
| `boot_a04e_v8a_v2.img` | 13MB | `4.19.191-gce92e45b9a05-dirty` | `2f68160e9655af4548a841c92aed1964` |
| `boot_a04e_v8a_v3.img` | 13MB | `4.19.191-gce92e45b9a05-dirty` | `3bc3d37233ce9db977bc4b2ab27afb5e` |
| `boot_a04e_v8a_v4diag2.img` | 13MB | `4.19.191-g0950e3ee5c82` | `4dc588e5a83248958774811ce6d16805` |
| `boot_a04e_v8a_v4diag7s.img` | 13MB | `4.19.191-g87a51cbcc833` | `35c65d0d687c275614b8950d183a2156` |
| `boot_a04e_v8a_v4diag.img` | 13MB | `4.19.191-gce92e45b9a05-dirty` | `57248877ceeffe2339b850d6bffaeeb9` |
| `boot_a04e_v8a_v4feed.img` | 13MB | `4.19.191-g9fefd911238f` | `dcc1c108e50e881aa2a7a56674d9851f` |
| `boot_a04e_v8a_v4snap.img` | 13MB | `4.19.191-g87a51cbcc833` | `176ca4b43ab54ccd2a4797520a348fbb` |
| `boot_a04e_v8a_v4verbose.img` | 13MB | `4.19.191-g87a51cbcc833` | `6b2df487196272f60667bde0a349248e` |
| `boot_a04e_v8a_v5blacklist2.img` | 13MB | `4.19.191-g87a51cbcc833` | `fdd87ef21eb4a180d78954543721838b` |
| `boot_a04e_v8a_v5blacklist.img` | 13MB | `4.19.191-g87a51cbcc833` | `54a13ee754fa70d3d0628903d37aac00` |
| `boot_v5_fullboot.img` | 13MB | `4.19.191-gd51438aa5c6f` | `8018e7086769a14c70f2a765e6ec1735` |
| `boot_v5_panic75.img` | 13MB | `4.19.191-g2f935e3df488` | `60d60a0574a3c28d5f4545ceb03a3eb5` |
| `boot_v8a_ce92e45b9_neuter.img` | 13MB | `4.19.191-gce92e45b9a05-dirty` | `69bda094ae9ec7c735d507c6191b309a` |
| `boot_wdt-feed.img` | 13MB | `4.19.191-g82c031685b2d` | `a894630cbb5e63990c266377d6319fb5` |

## v8a watchdog diagnostics (v20-v28)
See **BUILDLOG.md** for the md5 → kernel-commit → outcome table; images in **v8a_diagnostics/**. Source committed as 0f4d04523 on branch mid7021-wdt-readback.

## v8a TEE-graft frontier (2026-06-14)
| Image | Size | Kernel | md5 |
|---|---|---|---|
| `boot_v8a_pvrbridge900.img` | 13MB | `4.19.191-gdf4ff38a6 (A04e GPL PVR transplant, 900s deadline)` | `d1d6372f7cbf4f17caf2043d36ac805a` |
| `boot_v8a_pvrbridge900_dlptneuter.img` | 13MB | `4.19.191-gb913714a3628 (+dlpt false-poweroff neuter)` | `972ffd14c8c980c3c05b2045a70ea9ff` |
