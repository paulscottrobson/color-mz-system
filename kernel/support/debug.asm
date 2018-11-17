; *********************************************************************************
; *********************************************************************************
;
;		File:		debug.asm
;		Purpose:	Debug routines
;		Date : 		15th November 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

DEBUGShowStackBottomLine:
		pop 	ix 									; IX = return address
		push 	de 									; save register TOS on stack
		push	ix 									; save IX on stack

		push 	bc
		push 	de
		push 	hl

		ld 		hl,(SIScreenSize) 					; calculate start position
		ld 		de,(SIScreenWidth)
		xor		a
		sbc 	hl,de
		push 	hl
		ld 		c,e
		ld 		b,c 								; clear the bottom line.
__DSSSBLClear:
		ld 		de,$0220
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__DSSSBLClear
		pop 	hl 									; restore current position.
		ld 		ix,$0002+6 							; copy SP+2 into IX, one for pushed IX
		add 	ix,sp 								; one for each of pushed BC DE HL above
__DSSShowLoop:
		ld 		a,(SIStack) 						; reached Top of execute stack 
		cp 		ixl									; (assumes < 256 byte data stack)
		jr 		z,__DSSExit
		ld 		a,c 								; is there enough space ?
		cp 		5
		jr 		c,__DSSExit
		ld 		d,(ix+1)
		ld 		e,(ix+0)
		call 	__DSSPrintDecimal
		inc 	hl 									; leave a space
		dec 	c 									; one less character
		inc 	ix 									; next entry on stack.
		inc 	ix 
		jr 		__DSSShowLoop

__DSSExit:
		pop 	hl
		pop 	de
		pop 	bc

		pop 	ix 									; and return address
		pop 	de 	 								; restore old TOS.
		jp		(ix)								; and go there.

__DSSPrintDecimal:
		bit 	7,d
		jr 		z,__DSSPrintDecimalRec
		ld 		a,d
		cpl		
		ld 		d,a
		ld 		a,e
		cpl
		ld 		e,a
		inc 	de
		push 	de
		ld 		de,$0600+'-'
		call 	GFXWriteCharacter
		inc 	hl
		dec 	c
		pop 	de
__DSSPrintDecimalRec:	
		push 	hl
		ld 		hl,10
		call 	DIVDivideMod16
		ld 		a,d
		or 		e
		ex 		(sp),hl
		call 	nz,__DSSPrintDecimalRec
		pop 	de
		ld 		a,e
		add 	a,48
		ld 		e,a
		ld 		d,6
		call 	GFXWriteCharacter
		inc		hl
		dec 	c
		ret
