#!/usr/bin/env python3
# Transform ONLY the logical system/system_ext/vendor lines; keep everything else verbatim.
import sys
src=open("/tmp/fstab.orig").read().splitlines(keepends=True)
out=[]; injected=False
NEW=["system  /system  ext4  ro  wait,logical,first_stage_mount,slotselect\n",
     "vendor  /vendor  ext4  ro  wait,logical,first_stage_mount,slotselect\n"]
for ln in src:
    f=ln.split()
    first=f[0] if f else ""
    if first in ("system","system_ext","vendor"):
        if not injected:
            out.extend(NEW); injected=True
        # else: drop (collapse duplicates / drop system_ext)
    else:
        out.append(ln)
open("/tmp/fstab.new","w").write("".join(out))
print("wrote /tmp/fstab.new (%d -> %d lines)" % (len(src), len(out)))
