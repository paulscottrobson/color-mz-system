# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		showdictionary.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		15th November 2018
#		Purpose :	List Dictionary contents
#
# ***************************************************************************************
# ***************************************************************************************

import re
from imagelib import *


image = MZImage()
p = 0xC000
dictPage = image.dictionaryPage()

while image.read(dictPage,p) != 0:

	page = image.read(dictPage,p+1)
	addr = image.read(dictPage,p+2) + 256 * image.read(dictPage,p+3)
	name = ""
	for i in range(0,image.read(dictPage,p+4) & 0x3F):
		name = name + chr(image.read(dictPage,p+5+i))
	dByte = image.read(dictPage,p + 4)
	dest = "<word>" if (dByte & 0x80) == 0 else "<macro>"
	print("[{0:04x}] {4} {1:02x}:{2:04x} {3}".format(p,page,addr,name,dest))
	p = p + image.read(dictPage,p)