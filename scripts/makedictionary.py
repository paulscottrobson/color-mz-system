# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makedictionary.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		16th November 2018
#		Purpose :	Extract dictionary items from listing and put in image.
#
# ***************************************************************************************
# ***************************************************************************************

import re,imagelib

image = imagelib.MZImage()

src = [x.strip().lower() for x in open("boot.img.vice").readlines() if x.find("CFORTH") >= 0]
src = [x for x in src if x.find("forth__cforth") >=0 or x.find("macro__cforth") >= 0]

for line in src:
	#print(line)
	m = re.match("^al\s+c\:([0-9a-f]+)\s+\_(\w+)\_\_cforth_([\_0-9a-f]+)",line)
	assert m is not None,line+" bad"
	wType = m.group(2)
	wName = m.group(3)
	wName = "".join([chr(int(x,16)) for x in wName.split("_")])
	address = int(m.group(1),16)
	#print(wName,wType,address)
	image.addDictionary(wName,image.getCodePage(),address,wType == "macro")

image.save()
