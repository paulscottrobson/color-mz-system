;
; Generated.
;
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   binary.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   16th November 2018
;  Purpose : Binary operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== + generator ===========

forth__cforth_2b:
  add  hl,de
end__cforth_2b:
	ret

macro__cforth_2b:
	ld b,end__cforth_2b-forth__cforth_2b
	ld hl,forth__cforth_2b
	jp MacroExpand

; =========== - generator ===========

forth__cforth_2d:
  push  de
  ex   de,hl
  xor  a
  sbc  hl,de
  pop  de
end__cforth_2d:
	ret

macro__cforth_2d:
	ld b,end__cforth_2d-forth__cforth_2d
	ld hl,forth__cforth_2d
	jp MacroExpand

; =========== * word ===========

forth__cforth_2a:
  jp   MULTMultiply16

; =========== / word ===========

forth__cforth_2f:
  push  de
  call  DIVDivideMod16
  ex   de,hl
  pop  de
  ret

; =========== mod word ===========

forth__cforth_6d_6f_64:
  push  de
  call  DIVDivideMod16
  pop  de
  ret

; =========== and word ===========

forth__cforth_61_6e_64:
  ld   a,h
  and  d
  ld   h,a
  ld   a,l
  and  e
  ld   l,a
  ret

; =========== xor word ===========

forth__cforth_78_6f_72:
  ld   a,h
  xor   d
  ld   h,a
  ld   a,l
  xor  e
  ld   l,a
  ret

; =========== or word ===========

forth__cforth_6f_72:
  ld   a,h
  or   d
  ld   h,a
  ld   a,l
  or   e
  ld   l,a
  ret


; =========== max word ===========

forth__cforth_6d_61_78:
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__Max2
    push  hl
    sbc  hl,de
    pop  hl
    ret  nc
    ex   de,hl
    ret

__Max2:
 bit  7,h
 ret  z
 ex   de,hl
 ret

; =========== min word ===========

forth__cforth_6d_69_6e:
    ld      a,h
    xor     d
    bit  7,a
    jr      nz,__Min2
    push    hl
    sbc     hl,de
    pop     hl
    ret     c
    ex      de,hl
    ret

__Min2:
    bit     7,h
    ret     nz
    ex      de,hl
    ret
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   compare.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   17 November 2018
;  Purpose : Comparison words, min and max.
;
; ***************************************************************************************
; ***************************************************************************************

; =========== = word ===========

forth__cforth_3d:
 ld   a,h
 cp   d
 jr   nz,__COMFalse
 ld   a,l
 cp   e
 jr   nz,__COMFalse
__COMTrue:
 ld   hl,$FFFF
 ret
__COMFalse:
 ld   hl,$0000
 ret

; =========== <> word ===========

forth__cforth_3c_3e:
 ld   a,h
 cp   d
 jr   nz,__COM2True
 ld   a,l
 cp   e
 jr   z,__COM2False
__COM2True:
 ld   hl,$FFFF
 ret
__COM2False:
 ld   hl,$0000
 ret


; =========== > word ===========

forth__cforth_3e:
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__Greater
    sbc  hl,de
    jr   c,__COM3True
    jr   __COM3False
__Greater:
 bit  7,d
    jr   nz,__COM3False
__COM3True:
 ld   hl,$FFFF
 ret
__COM3False:
 ld   hl,$0000
 ret

; =========== <= word ===========

forth__cforth_3c_3d:
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__LessEqual
    sbc  hl,de
    jr   nc,__COM4True
    jr   __COM4False
__LessEqual:
 bit  7,d
    jr   z,__COM4False
__COM4True:
 ld   hl,$FFFF
 ret
__COM4False:
 ld   hl,$0000
 ret

; =========== >= word ===========

forth__cforth_3e_3d:
 dec  hl
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__Greater2
    sbc  hl,de
    jr   c,__COM6True
    jr   __COM6False
__Greater2:
 bit  7,d
    jr   nz,__COM6False
__COM6True:
 ld   hl,$FFFF
 ret
__COM6False:
 ld   hl,$0000
 ret

; =========== < word ===========

forth__cforth_3c:
 dec  hl
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__LessEqual2
    sbc  hl,de
    jr   nc,__COM5True
    jr   __COM5False
__LessEqual2:
 bit  7,d
    jr   z,__COM5False
__COM5True:
 ld   hl,$FFFF
 ret
__COM5False:
 ld   hl,$0000
 ret
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   graphic.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   17th November 2018
;  Purpose : Graphic System words
;
; ***************************************************************************************
; ***************************************************************************************

; *********************************************************************************

; =========== mode.48 word ===========

forth__cforth_6d_6f_64_65_2e_34_38:
  push  de
  call  GFXInitialise48k
  call  GFXConfigure
  pop  de

; *********************************************************************************

; =========== mode.lowres word ===========

forth__cforth_6d_6f_64_65_2e_6c_6f_77_72_65_73:
  push  de
  call  GFXInitialiseLowRes
  call  GFXConfigure
  pop  de

; *********************************************************************************

; =========== mode.layer2 word ===========

forth__cforth_6d_6f_64_65_2e_6c_61_79_65_72_32:
  push  de
  call  GFXInitialiseLayer2
  call  GFXConfigure
  pop  de

; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   memory.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   17th November 2018
;  Purpose : Memory and Hardware access
;
; ***************************************************************************************
; ***************************************************************************************

; =========== c@ generator ===========

forth__cforth_63_40:
  ld   l,(hl)
  ld   h,0
end__cforth_63_40:
	ret

macro__cforth_63_40:
	ld b,end__cforth_63_40-forth__cforth_63_40
	ld hl,forth__cforth_63_40
	jp MacroExpand

; =========== @ generator ===========

forth__cforth_40:
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
end__cforth_40:
	ret

macro__cforth_40:
	ld b,end__cforth_40-forth__cforth_40
	ld hl,forth__cforth_40
	jp MacroExpand

; =========== c! generator ===========

forth__cforth_63_21:
  ld   (hl),e
end__cforth_63_21:
	ret

macro__cforth_63_21:
	ld b,end__cforth_63_21-forth__cforth_63_21
	ld hl,forth__cforth_63_21
	jp MacroExpand

; =========== ! generator ===========

forth__cforth_21:
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
end__cforth_21:
	ret

macro__cforth_21:
	ld b,end__cforth_21-forth__cforth_21
	ld hl,forth__cforth_21
	jp MacroExpand

; =========== +! word ===========

forth__cforth_2b_21:
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl

  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  dec  hl
  ret

; =========== p! word ===========

forth__cforth_70_21:
  push  bc
  ld   c,l
  ld   b,h
  out  (c),e
  pop  bc
  ret

; =========== p@ word ===========

forth__cforth_70_40:
  push  bc
  ld   c,l
  ld   b,h
  in   l,(c)
  ld   h,0
  pop  bc
  ret
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   register.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   17th November 2018
;  Purpose : Register operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== swap generator ===========

forth__cforth_73_77_61_70:
 ex   de,hl
end__cforth_73_77_61_70:
	ret

macro__cforth_73_77_61_70:
	ld b,end__cforth_73_77_61_70-forth__cforth_73_77_61_70
	ld hl,forth__cforth_73_77_61_70
	jp MacroExpand

; =========== a>b generator ===========

forth__cforth_61_3e_62:
 ld   d,h
 ld   e,l
end__cforth_61_3e_62:
	ret

macro__cforth_61_3e_62:
	ld b,end__cforth_61_3e_62-forth__cforth_61_3e_62
	ld hl,forth__cforth_61_3e_62
	jp MacroExpand

; =========== b>a generator ===========

forth__cforth_62_3e_61:
 ld   h,d
 ld   l,e
end__cforth_62_3e_61:
	ret

macro__cforth_62_3e_61:
	ld b,end__cforth_62_3e_61-forth__cforth_62_3e_61
	ld hl,forth__cforth_62_3e_61
	jp MacroExpand

; =========== a>c generator ===========

forth__cforth_61_3e_63:
 ld   b,h
 ld   c,l
end__cforth_61_3e_63:
	ret

macro__cforth_61_3e_63:
	ld b,end__cforth_61_3e_63-forth__cforth_61_3e_63
	ld hl,forth__cforth_61_3e_63
	jp MacroExpand

; =========== c>a generator ===========

forth__cforth_63_3e_61:
 ld   h,b
 ld   l,c
end__cforth_63_3e_61:
	ret

macro__cforth_63_3e_61:
	ld b,end__cforth_63_3e_61-forth__cforth_63_3e_61
	ld hl,forth__cforth_63_3e_61
	jp MacroExpand

; =========== b>c generator ===========

forth__cforth_62_3e_63:
 ld   b,d
 ld   c,e
end__cforth_62_3e_63:
	ret

macro__cforth_62_3e_63:
	ld b,end__cforth_62_3e_63-forth__cforth_62_3e_63
	ld hl,forth__cforth_62_3e_63
	jp MacroExpand

; =========== c>b generator ===========

forth__cforth_63_3e_62:
 ld   d,b
 ld   e,c
end__cforth_63_3e_62:
	ret

macro__cforth_63_3e_62:
	ld b,end__cforth_63_3e_62-forth__cforth_63_3e_62
	ld hl,forth__cforth_63_3e_62
	jp MacroExpand
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   stack.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   17th November 2018
;  Purpose : Stack operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== a>r generator ===========

forth__cforth_61_3e_72:
 push  hl
end__cforth_61_3e_72:
	ret

macro__cforth_61_3e_72:
	ld b,end__cforth_61_3e_72-forth__cforth_61_3e_72
	ld hl,forth__cforth_61_3e_72
	jp MacroExpand

; =========== b>r generator ===========

forth__cforth_62_3e_72:
 push  de
end__cforth_62_3e_72:
	ret

macro__cforth_62_3e_72:
	ld b,end__cforth_62_3e_72-forth__cforth_62_3e_72
	ld hl,forth__cforth_62_3e_72
	jp MacroExpand

; =========== c>r generator ===========

forth__cforth_63_3e_72:
 push  bc
end__cforth_63_3e_72:
	ret

macro__cforth_63_3e_72:
	ld b,end__cforth_63_3e_72-forth__cforth_63_3e_72
	ld hl,forth__cforth_63_3e_72
	jp MacroExpand

; =========== ab>r generator ===========

forth__cforth_61_62_3e_72:
 push  de
 push  hl
end__cforth_61_62_3e_72:
	ret

macro__cforth_61_62_3e_72:
	ld b,end__cforth_61_62_3e_72-forth__cforth_61_62_3e_72
	ld hl,forth__cforth_61_62_3e_72
	jp MacroExpand

; =========== abc>r generator ===========

forth__cforth_61_62_63_3e_72:
 push  bc
 push  de
 push  hl
end__cforth_61_62_63_3e_72:
	ret

macro__cforth_61_62_63_3e_72:
	ld b,end__cforth_61_62_63_3e_72-forth__cforth_61_62_63_3e_72
	ld hl,forth__cforth_61_62_63_3e_72
	jp MacroExpand

; =========== r>a generator ===========

forth__cforth_72_3e_61:
 pop  hl
end__cforth_72_3e_61:
	ret

macro__cforth_72_3e_61:
	ld b,end__cforth_72_3e_61-forth__cforth_72_3e_61
	ld hl,forth__cforth_72_3e_61
	jp MacroExpand

; =========== r>b generator ===========

forth__cforth_72_3e_62:
 pop  de
end__cforth_72_3e_62:
	ret

macro__cforth_72_3e_62:
	ld b,end__cforth_72_3e_62-forth__cforth_72_3e_62
	ld hl,forth__cforth_72_3e_62
	jp MacroExpand

; =========== r>c generator ===========

forth__cforth_72_3e_63:
 pop  bc
end__cforth_72_3e_63:
	ret

macro__cforth_72_3e_63:
	ld b,end__cforth_72_3e_63-forth__cforth_72_3e_63
	ld hl,forth__cforth_72_3e_63
	jp MacroExpand

; =========== r>ab generator ===========

forth__cforth_72_3e_61_62:
 pop  hl
 pop  de
end__cforth_72_3e_61_62:
	ret

macro__cforth_72_3e_61_62:
	ld b,end__cforth_72_3e_61_62-forth__cforth_72_3e_61_62
	ld hl,forth__cforth_72_3e_61_62
	jp MacroExpand

; =========== r>abc generator ===========

forth__cforth_72_3e_61_62_63:
 pop  hl
 pop  de
 pop  bc
end__cforth_72_3e_61_62_63:
	ret

macro__cforth_72_3e_61_62_63:
	ld b,end__cforth_72_3e_61_62_63-forth__cforth_72_3e_61_62_63
	ld hl,forth__cforth_72_3e_61_62_63
	jp MacroExpand
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   unary.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   17th November 2018
;  Purpose : Unary operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== 0= word ===========

forth__cforth_30_3d:
  ld  a,h
  or  l
  ld  hl,$0000
  ret nz
  dec hl
  ret

; =========== 0< word ===========

forth__cforth_30_3c:
  bit 7,h
  ld  hl,$0000
  ret z
  dec hl
  ret

; =========== 0- word ===========

forth__cforth_30_2d:
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  inc hl
  ret

; =========== not word ===========

forth__cforth_6e_6f_74:
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  ret

; =========== abs word ===========

forth__cforth_61_62_73:
  bit 7,h
  ret z
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  inc hl
  ret


; =========== 1+ generator ===========

forth__cforth_31_2b:
  inc hl
end__cforth_31_2b:
	ret

macro__cforth_31_2b:
	ld b,end__cforth_31_2b-forth__cforth_31_2b
	ld hl,forth__cforth_31_2b
	jp MacroExpand

; =========== 1- generator ===========

forth__cforth_31_2d:
  dec hl
end__cforth_31_2d:
	ret

macro__cforth_31_2d:
	ld b,end__cforth_31_2d-forth__cforth_31_2d
	ld hl,forth__cforth_31_2d
	jp MacroExpand

; =========== 2+ generator ===========

forth__cforth_32_2b:
  inc hl
  inc hl
end__cforth_32_2b:
	ret

macro__cforth_32_2b:
	ld b,end__cforth_32_2b-forth__cforth_32_2b
	ld hl,forth__cforth_32_2b
	jp MacroExpand

; =========== 2- generator ===========

forth__cforth_32_2d:
  dec hl
  dec hl
end__cforth_32_2d:
	ret

macro__cforth_32_2d:
	ld b,end__cforth_32_2d-forth__cforth_32_2d
	ld hl,forth__cforth_32_2d
	jp MacroExpand


; =========== 2* generator ===========

forth__cforth_32_2a:
  add  hl,hl
end__cforth_32_2a:
	ret

macro__cforth_32_2a:
	ld b,end__cforth_32_2a-forth__cforth_32_2a
	ld hl,forth__cforth_32_2a
	jp MacroExpand

; =========== 2/ generator ===========

forth__cforth_32_2f:
  sra  h
  rr   l
end__cforth_32_2f:
	ret

macro__cforth_32_2f:
	ld b,end__cforth_32_2f-forth__cforth_32_2f
	ld hl,forth__cforth_32_2f
	jp MacroExpand

; =========== 4* generator ===========

forth__cforth_34_2a:
  add  hl,hl
  add  hl,hl
end__cforth_34_2a:
	ret

macro__cforth_34_2a:
	ld b,end__cforth_34_2a-forth__cforth_34_2a
	ld hl,forth__cforth_34_2a
	jp MacroExpand

; =========== 4/ word ===========

forth__cforth_34_2f:
  sra  h
  rr   l
  sra  h
  rr   l
  ret

; =========== 8* generator ===========

forth__cforth_38_2a:
  add  hl,hl
  add  hl,hl
  add  hl,hl
end__cforth_38_2a:
	ret

macro__cforth_38_2a:
	ld b,end__cforth_38_2a-forth__cforth_38_2a
	ld hl,forth__cforth_38_2a
	jp MacroExpand


; =========== 16* generator ===========

forth__cforth_31_36_2a:
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
end__cforth_31_36_2a:
	ret

macro__cforth_31_36_2a:
	ld b,end__cforth_31_36_2a-forth__cforth_31_36_2a
	ld hl,forth__cforth_31_36_2a
	jp MacroExpand

; =========== 16/ word ===========

forth__cforth_31_36_2f:
  sra  h
  rr   l
  sra  h
  rr   l
  sra  h
  rr   l
  sra  h
  rr   l
  ret

; =========== 256* generator ===========

forth__cforth_32_35_36_2a:
  ld   h,l
  ld   l,0
end__cforth_32_35_36_2a:
	ret

macro__cforth_32_35_36_2a:
	ld b,end__cforth_32_35_36_2a-forth__cforth_32_35_36_2a
	ld hl,forth__cforth_32_35_36_2a
	jp MacroExpand

; =========== 256/ word ===========

forth__cforth_32_35_36_2f:
  ld   l,h
  ld   h,0
  bit  7,l
  ret  z
  dec  h
  ret

; =========== bswap generator ===========

forth__cforth_62_73_77_61_70:
  ld   a,l
  ld   l,h
  ld   h,a
end__cforth_62_73_77_61_70:
	ret

macro__cforth_62_73_77_61_70:
	ld b,end__cforth_62_73_77_61_70-forth__cforth_62_73_77_61_70
	ld hl,forth__cforth_62_73_77_61_70
	jp MacroExpand
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   utility.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   17th November 2018
;  Purpose : Miscellaneous words.
;
; ***************************************************************************************
; ***************************************************************************************

; =========== break generator ===========

forth__cforth_62_72_65_61_6b:
  db   $DD,$01
end__cforth_62_72_65_61_6b:
	ret

macro__cforth_62_72_65_61_6b:
	ld b,end__cforth_62_72_65_61_6b-forth__cforth_62_72_65_61_6b
	ld hl,forth__cforth_62_72_65_61_6b
	jp MacroExpand

; =========== sys.info word ===========

forth__cforth_73_79_73_2e_69_6e_66_6f:
  ex   de,hl
  ld   hl,SystemInformationTable
  ret

; =========== ; generator ===========

forth__cforth_3b:
  ret
end__cforth_3b:
	ret

macro__cforth_3b:
	ld b,end__cforth_3b-forth__cforth_3b
	ld hl,forth__cforth_3b
	jp MacroExpand

; =========== inkey word ===========

forth__cforth_69_6e_6b_65_79:
  ex   de,hl
  call  IOScanKeyboard
  ld   l,a
  ld   h,0
  ret

; =========== halt word ===========

forth__cforth_68_61_6c_74:
HaltZ80:
  di
  halt
  jr   HaltZ80

; =========== copy word ===========

forth__cforth_63_6f_70_79:
  ld   a,b         ; nothing to do.
  or   c
  ret  z

  push  bc
  push  de
  push  hl

  xor  a          ; find direction.
  sbc  hl,de
  ld   a,h
  add  hl,de
  bit  7,a         ; if +ve use LDDR
  jr   z,__copy2

  ex   de,hl         ; LDIR etc do (DE) <- (HL)
  ldir
__copyExit:
  pop  hl
  pop  de
  pop  bc
  ret

__copy2:
  add  hl,bc         ; add length to HL,DE, swap as LDDR does (DE) <- (HL)
  ex   de,hl
  add  hl,bc
  dec  de          ; -1 to point to last byte
  dec  hl
  lddr
  jr   __copyExit

; =========== fill word ===========

forth__cforth_66_69_6c_6c:
  ld   a,b         ; nothing to do.
  or   c
  ret  z
  push bc
  push  hl

__fill1:ld   (hl),e
  inc  hl
  dec  bc
  ld   a,b
  or   c
  jr   nz,__fill1

  pop  hl
  pop  bc
  ret
