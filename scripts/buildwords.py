# *********************************************************************************
# *********************************************************************************
#
#		File:		buildwords.py
#		Purpose:	Build composite assembly file to generate scaffolding code.
#		Date : 		17th November 2018
#		Author:		paul@robsons.org.uk
#
# *********************************************************************************
# *********************************************************************************

import os,re
#
#		Get list of word files.
#
fileList = []
for root,dirs,files in os.walk("source"):
	for f in [x for x in files if x[-6:] == ".words"]:
		fileList.append(root+os.sep+f)
fileList.sort()
#
#		Now process them
#
hOut = open("__words.asm","w")
hOut.write(";\n; Generated.\n;\n")
for f in fileList:
	unclosedWord = None
	for l in [x.rstrip().replace("\t"," ") for x in open(f).readlines()]:
		#print(l)
		#
		#		Look for @<marker>.<wrapper> <word> or @end
		#
		if l != "" and l[0] == ";" and l.find("@") >= 0 and l.find("@") < 4:
			m = re.match("^\;\s+\@(\w+)\s*(.*)$",l)
			assert m is not None,l+" syntax ?"
			marker = m.group(1).lower().strip()
			word = m.group(2).lower().strip()
			#
			#		Quick check.
			#
			assert marker == "generator" or marker == "word" or marker == "end",l
			#print(marker,word)
			#
			#		If it isn't end, create an executable with the wrapper
			#
			if marker != "end":
				assert unclosedWord is None,"Not closed at "+l
				unclosedWord = "_cforth_"+("_".join(["{0:02x}".format(ord(x)) for x in word]))
				unclosedIsGenerator = (marker == "generator")
				hOut.write("; =========== {0} {1} ===========\n\n".format(word,marker))
				hOut.write("forth_"+unclosedWord+":\n")
			#
			#		If it is an end, mark the end if it is a generator, then complete
			# 		the wrapper from the start. Then for generators create a macro word
			# 		which creates he code to copy the word.
			#
			else:
				assert unclosedWord is not None
				if unclosedIsGenerator:
					hOut.write("end_"+unclosedWord+":\n")
					hOut.write("\tret\n")

				if unclosedIsGenerator:
					hOut.write("\nmacro_"+unclosedWord+":\n")
					hOut.write("\tld b,end_{0}-forth_{0}\n".format(unclosedWord))
					hOut.write("\tld hl,forth_{0}\n".format(unclosedWord))
					hOut.write("\tjp MacroExpand\n")
				unclosedWord = None
		else:
			hOut.write(l+"\n")
hOut.close()
