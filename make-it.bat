@echo off
calc_mode7_scaling_tables.py
echo [objects] > furryrpg.lnk
echo furryrpg.obj >> furryrpg.lnk
wla-65816 -xo furryrpg.asm furryrpg.obj
wlalink -rs furryrpg.lnk furryrpg.sfc
del furryrpg.lnk
pause
