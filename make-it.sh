#!/bin/bash

python calc_mode7_scaling_tables.py
echo -e '[objects]\nfurryrpg.obj' >> furryrpg.lnk
wla-65816 -x -o furryrpg.obj furryrpg.asm
wlalink -r -s furryrpg.lnk furryrpg.sfc
rm furryrpg.lnk
echo 'Press any key to continue...'
read -n 1 -s
