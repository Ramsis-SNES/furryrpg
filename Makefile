# ==================================================================================================
#
#	"FURRY RPG" (WORKING TITLE)
#	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
#
#	MAKEFILE
#
# ==================================================================================================



# Requirements: see README.md

AS=wla-65816
ASFLAGS=-x -o
LD=wlalink
LDFLAGS=-r -s
SHELL=/bin/bash

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

$(msu):
	touch $@
	cp -u music/ambient/nightingale.pcm $(target)-1.pcm

$(obj): $(src) bindata
	$(AS) $(ASFLAGS) $@ $<

$(sfc): $(obj)
	echo -e '[objects]\n$<' > $(lnk)
	$(LD) $(LDFLAGS) $(lnk) $@
#	cd tools; \
#	./$(chsumscript) ../$@

$(swc): $(sfc)
	cat $(header) $< > $@

bindata:
	cd tools; \
	python $(pyscript_m7)

clean:
	-rm -f $(lnk) $(msu) $(obj) $(sfc) $(swc) $(sym) *.pcm data/mode7_scalingtables.bin

gfx:
	cd gfx; \
#	superfamiconv
