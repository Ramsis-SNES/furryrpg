@echo off

echo -- CONVERTING LOGO --
gfx2snes -gs8 -pc256 -po256 -fpcx -m -n logo.pcx

rem ****** Old command line syntax for neviksti's tool:
rem ****** pcx2snes %filename% -n -s8 -c16 -o16

echo -- CONVERTING PORTRAITS --
gfx2snes -gs8 -mR! -pc16 -po16 -fpcx -n portrait_kimahri.pcx
gfx2snes -gs8 -mR! -pc16 -po16 -fpcx -n portrait_linkwolf.pcx
gfx2snes -gs8 -mR! -pc16 -po16 -fpcx -n portrait_gengen.pcx
gfx2snes -gs8 -mR! -pc16 -po16 -fpcx -n portrait_zakari.pcx

echo -- CONVERTING FONTS --
gfx2snes -gs8 -mR! -p! -pc4 -fbmp -n font_mode5.bmp
gfx2snes -gs8 -mR! -p! -pc4 -fpcx -n font_hud.pcx
gfx2snes -gs8 -mR! -po16 -pc16 -fpcx -n font_sprites_big.pcx
rem gfx2snes -gs8 -mR! -p! -pc16 -fbmp -n font_4bpp.bmp

echo -- CONVERTING PLAYFIELDS --
gfx2snes -gs8 -m -pc256 -po256 -fpcx -n playfield_001.pcx
gfx2snes -gs8 -m -pc16 -po16 -fpcx -n area-001-sandbox.pcx


echo -- CONVERTING MODE 7 GFX --

gfx2snes -m7 -po256 -fbmp map.bmp

echo -- FINISHED! --
pause
