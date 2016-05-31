@echo off
calc_mode7_scaling_tables.py
echo [objects] > furryrpg.lnk
echo furryrpg.obj >> furryrpg.lnk
wla-65816 -x -o furryrpg.obj furryrpg.asm
wlalink -r -s furryrpg.lnk furryrpg.sfc
del furryrpg.lnk
pause
