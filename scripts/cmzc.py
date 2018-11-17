# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		cmzc.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		17th November 2018
#		Purpose :	Python simple Colour MZ Compiler.
#
# ***************************************************************************************
# ***************************************************************************************
# 	Supports:
#
#		:<word> 			Represents <word> in red
#		<word>				A word in green which is compiled (e.g. macro then forth)
#		"<string>"			A string constant, with space replacing underscore
#  		<integer> 			An integer constant with the -ve postfix.
#		<internal macro>	Support if -if then for next -next begin until -until end
#							word macro !! and @@ now become post-operators.
# 		// 					comments
#
# ***************************************************************************************

from imagelib import *
import re,sys

# ***************************************************************************************
#									Compiler Exception code
# ***************************************************************************************

class CompilerException(Exception):
	def __init__(self,msg):
		Exception.__init__(self)
		self.errorMessage = msg

# ***************************************************************************************
#										Code Generator
# ***************************************************************************************

class Z80CodeGenerator(object):
	def __init__(self,image):
		self.image = image
	#
	#		Compile a call
	#
	def compileCall(self,page,address):
		if address >= 0xC000:
			if page != self.image.getCodePage():
				assert "Paging calling code needs to be added"
		self.image.cByte(0xCD)							# CALL xxxx
		self.image.cWord(address)
	#
#		Expand a macro - we have to do this manually.
	#
	def expandMacro(self,address):
		assert address < 0xC000,"Coded for macros in $8000-$BFFF"
		assert self.image.read(0,address) == 6
		assert self.image.read(0,address+2) == 33
		assert self.image.read(0,address+5) == 195
		count = self.image.read(0,address+1)
		macAddress = self.image.read(0,address+3)+self.image.read(0,address+4) * 256
		print(address,macAddress)
		assert count < 7
		for i in range(0,count):
			self.image.cByte(self.image.read(0,macAddress+i))
	#
	#		Compile code to push constant on stack
	#
	def compileConstant(self,const):
		self.image.cByte(0xEB)							# EX DE,HL
		self.image.cByte(0x21)							# LD HL,xxxx
		self.image.cWord(const)
	#
	#		Compile string - somewhere - doing it inline here.
	#
	def compileString(self,string):
		self.image.cByte(0x18)							# JR xx
		self.image.cByte(len(string)+1)
		addr = self.image.getCodeAddress()
		for c in string:
			self.image.cByte(ord(c) if c != '_' else 0x20)
		self.image.cByte(0x00)
		return addr

# ***************************************************************************************
#								Compiler Class
# ***************************************************************************************

class Compiler(object):
	def __init__(self,sourceImage = "boot.img",targetImage = "boot.img"):
		self.image = MZImage(sourceImage)
		self.codeGen = Z80CodeGenerator(self.image)
		self.targetImage = targetImage
		Compiler.WORD = 0
		Compiler.MACRO = 1
		self.mode = Compiler.WORD
	#
	#		Compile a text list
	#
	def compileTextList(self,list):
		for l in range(0,len(list)):
			CompilerException.LINENUMBER = l + 1
			line = list[l].replace("\t"," ").strip()
			line = line if line.find("//") < 0 else line[:line.find("//")].strip()
			for word in [x for x in line.split(" ") if x != ""]:
				self.compileWord(word)
	#
	#		Compile a single word.
	#
	def compileWord(self,word):
		if self.image.echo:
			print("==== {0} ====".format(word))
		#
		#		String 
		#
		if len(word) >= 2 and word[0] == '"' and word[-1] == '"':
			constAddr = self.codeGen.compileString(word[1:-1])
			self.codeGen.compileConstant(constAddr)
			return
		#
		#		Definition
		#
		word = word.lower()
		if word[0] == ':' and len(word) > 1:
			self.image.addDictionary(word[1:],self.image.getCodePage(),	\
						self.image.getCodeAddress(),self.mode == Compiler.MACRO)
			if word[1:] == "main":
				self.image.setBootAddress(self.image.getCodePage(),self.image.getCodeAddress())
			return
		#
		#		Word
		#
		wordInfo = self.image.findWord(word,True)
		if wordInfo is None:
			wordInfo = self.image.findWord(word,False)
		if wordInfo is not None:
			if wordInfo[3]:
				self.codeGen.expandMacro(wordInfo[2])
			else:
				self.codeGen.compileCall(wordInfo[1],wordInfo[2])
			return
		#
		#		Constant
		#
		m = re.match("^(\-?)(\d+)$",word)
		if m is not None:
			const = int(m.group(2))
			if m.group(1) == "-":
				const = -const
			self.codeGen.compileConstant(const & 0xFFFF)
			return
		#
		#		Internal words
		#

		raise CompilerException("Unknown word "+word)

w = Compiler()
src = """
:hello	swap	c!	inkey	520 	

:main
	-3 2 "ab_Cd" 	// comments
	 halt
""".split("\n")
w.compileTextList(src)
w.image.save()
