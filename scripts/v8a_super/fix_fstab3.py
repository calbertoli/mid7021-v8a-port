#!/usr/bin/env python3
# 1) logical entries: keep ONLY system+vendor (slotselect); drop product/odm/system_ext.
# 2) A04e by-name mounts not in the MID7021 boot fstab (/cache, /mnt/vendor/efs): add nofail
#    so absence is tolerated. prism/optics already nofail. Real MTK mounts (protect/nvdata/
#    nvcfg/persist) + /data + /metadata left exactly as-is.
src=open("/tmp/fstab.orig").read().splitlines(keepends=True)
out=[]; injected=False
NEW=["system  /system  ext4  ro  wait,logical,first_stage_mount,slotselect\n",
     "vendor  /vendor  ext4  ro  wait,logical,first_stage_mount,slotselect\n"]
NOFAIL_MOUNTS={"/cache","/mnt/vendor/efs"}
for ln in src:
    f=ln.split(); first=f[0] if f else ""
    if first and not first.startswith("/") and not first.startswith("#"):
        if first in ("system","vendor"):
            if not injected: out.extend(NEW); injected=True
        # else drop phantom logical
    elif len(f)>=5 and f[1] in NOFAIL_MOUNTS and "nofail" not in f[4]:
        f[4]=f[4].rstrip(",")+",nofail"
        out.append("\t".join(f[:5])+"\n")
    else:
        out.append(ln)
open("/tmp/fstab.new","w").write("".join(out))
print("wrote /tmp/fstab.new (%d -> %d lines)"%(len(src),len(out)))
