# ==================================================================================================
#
#	"FURRY RPG" (WORKING TITLE)
#	(c) by Ramsis a.k.a. ManuLoewe (https://manuloewe.de/)
#
#	SCRIPT TO CREATE MODE 7 SCALING TABLES
#
# ==================================================================================================



#old:
# generate tables for 128 altitude settings, 152 scanlines each:
# altitude 0:  $800 / $20, $24, $28 ... $27C
# altitude 1: $1000 / $20, $24, $28 ... $27C
# altitude 2: $1800 / $20, $24, $28 ... $27C
# ...

#new:
# generate tables for 112 altitude settings, 152 scanlines each:
# altitude 0  :  $8800 / $20, $24, $28 ... $27C
# altitude 1  :  $9000 / $20, $24, $28 ... $27C
# altitude 2  :  $9800 / $20, $24, $28 ... $27C
# ...
# altitude 111: $40000 / $20, $24, $28 ... $27C

import struct

tables = open('../data/mode7_scalingtables.bin', 'wb')
dividend=0x8800
#divisor=0x20

def current_range(start, end, step):
	while (start < end):
		yield start
		start += step

while (dividend <= 0x40000):

	for divisor in current_range (0x20, 0x280, 4): #(0x80, 0x160, 1): # steep angle
		result = dividend // divisor
		tables.write(struct.pack('H', result))

	dividend += 0x800

tables.close()
