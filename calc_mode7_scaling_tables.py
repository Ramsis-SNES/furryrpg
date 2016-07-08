#==========================================================================================
#
#   "FURRY RPG" (WORKING TITLE)
#   (c) 2016 by Ramsis a.k.a. ManuLoewe (http://www.manuloewe.de/)
#
#	*** SCRIPT TO CREATE MODE 7 SCALING TABLES ***
#
#==========================================================================================



import struct

tables = open('data/tbl_mode7_scaling.bin', 'wb')
dividend=0x800
#divisor=0x20

def current_range(start, end, step):
	while (start < end):
		yield start
		start += step

while (dividend <= 0x40000):

	for divisor in current_range (0x20, 0x3A0, 4): #(0x80, 0x160, 1): # steep angle
		result = dividend / divisor
		tables.write(struct.pack('H', result))

	dividend += 0x800

tables.close()
