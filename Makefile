#==========================================================================================
#
#   "FURRY RPG" (WORKING TITLE)
#   (c) 201X by Ramsis a.k.a. ManuLoewe (https://manuloewe.de/)
#
#	*** MAKEFILE ***
#
#==========================================================================================



# This requires Python2 (I use v2.7.12), and the WLA DX assembler (v9.8a or newer).
# Graphics conversion (not supported yet) will require the Foxen snes-tile-tool.py
# (freely available from https://github.com/fo-fo/snes-tile-tool). ;-)

AS=wla-65816
ASFLAGS=-x -o
LD=wlalink
LDFLAGS=-r -s

target=furryrpg

#chsumscript=fix_chsum_exhirom_48mbit
pyscript_gfx=snes-tile-tool.py
pyscript_m7=calc_mode7_scaling_tables.py

lnk=$(target).lnk
msu=$(target).msu
obj=$(target).obj
sfc=$(target).sfc
src=$(target).asm
sym=$(target).sym

.PHONY: bindata clean gfx

all: bindata $(msu) $(sfc)

$(sfc): $(obj)
	$(LD) $(LDFLAGS) $(lnk) $(sfc)
#	cd tools && \
#	./$(chsumscript) ../$(sfc)

$(msu):
	touch $(msu)

$(obj): $(src)
	$(AS) $(ASFLAGS) $@ $<
	echo '[objects]\n$@' > $(lnk)

bindata:
	python $(pyscript_m7)

gfx:
	cd gfx && \
	python $(pyscript_gfx)

clean:
	-rm $(lnk) $(msu) $(obj) $(sfc) $(sym) data/tbl_mode7_scaling.bin
