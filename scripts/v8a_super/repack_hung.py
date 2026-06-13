#!/usr/bin/env python3
import subprocess, shlex, sys, os
MKB="/home/poca/mid7021/mkbootimg"
SRC="/home/poca/mid7021/v8a_a04e/boot_v8a_seldevelop.img"
OUT="/home/poca/mid7021/v8a_a04e/boot_v8a_seldevelop_hung.img"
W="/tmp/hungpack"
os.makedirs(W, exist_ok=True)
# get mkbootimg-style args (also extracts kernel/ramdisk/dtb into W)
args_str=subprocess.check_output(["python3",MKB+"/unpack_bootimg.py","--boot_img",SRC,"--out",W,"--format=mkbootimg"]).decode()
args=shlex.split(args_str)
# append hung_task_panic=1 to --cmdline
for i,a in enumerate(args):
    if a=="--cmdline":
        if "hung_task_panic" not in args[i+1]:
            args[i+1]=args[i+1].rstrip()+" hung_task_panic=1"
        print("NEW CMDLINE:", args[i+1][:160], "...")
        break
else:
    print("FAIL: no --cmdline in args"); sys.exit(2)
cmd=["python3",MKB+"/mkbootimg.py"]+args+["--output",OUT]
subprocess.check_call(cmd)
print("BUILT", OUT)
