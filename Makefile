#==========================================================================================
#
#   "FURRY RPG" (WORKING TITLE)
#   (c) 2023 by Ramsis a.k.a. ManuLoewe (https://manuloewe.de/)
#
#	*** MAKEFILE ***
#
#==========================================================================================



# This requires Python2 (I use v2.7.18), and the WLA DX cross assembler v10.4.
# Graphics conversion (not implemented yet) will require superfamiconv
# (available at https://github.com/Optiroc/SuperFamiconv).

AS=wla-65816
ASFLAGS=-x -o
LD=wlalink
LDFLAGS=-r -s

# name of ROM and associated files
target=furryrpg

#chsumscript=fix_chsum_exhirom_48mbit
header=swc_header_exhirom_sram.bin
pyscript_m7=calc_mode7_scaling_tables.py

lnk=$(target).lnk
msu=$(target).msu
obj=$(target).obj
sfc=$(target).sfc
src=$(target).asm
swc=$(target).swc
sym=$(target).sym

.PHONY: all bindata clean gfx

all: $(msu) $(sfc) $(swc)

$(sfc): bindata $(obj)
	$(LD) $(LDFLAGS) $(lnk) $(sfc)
#	cd tools && \
#	./$(chsumscript) ../$(sfc)

$(swc): $(sfc)
	cat $(header) $(sfc) > $(swc)

$(msu):
	touch $(msu)

$(obj): $(src)
	$(AS) $(ASFLAGS) $@ $<
	echo '[objects]\n$@' > $(lnk)

bindata:
	cd tools && \
	python $(pyscript_m7) && \
	cd ..

gfx:
	cd gfx && \
#	superfamiconv && \
	cd ..

clean:
	-rm -f $(lnk) $(msu) $(obj) $(sfc) $(swc) $(sym) data/mode7_scalingtables.bin
