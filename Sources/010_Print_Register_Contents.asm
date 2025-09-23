;----------------------------------------------------------------------------
; Core constants for ZX Spectrum 48K: memory map, screen/attribute layout,
; colors, keyboard ports/keycodes, ROM char addresses, and project addresses
;----------------------------------------------------------------------------
  include "Include/Constants.inc"
  include "Include/Macros.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   MAIN SUBROUTINE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ;---------------------------------------------
  ; Real life example - see which registers get
  ; clobbered with a call to Print_Character
  ;---------------------------------------------
  call Print_Registers_Main
  push AF
  push BC
  push DE
  push HL
  call Print_Character
  pop HL
  pop DE
  pop BC
  pop AF
  call Print_Registers_Main

; Academic example  ;--------------------------------------------
; Academic example  ; Set registers to some test value and print
; Academic example  ; register contents for the first time
; Academic example  ;--------------------------------------------
; Academic example  ld BC, $F7FE  ; example value
; Academic example  ld DE, $3344  ; example value
; Academic example  ld HL, $ABCD  ; example value
; Academic example
; Academic example  exx
; Academic example  ld BC, $FEF7  ; example value
; Academic example  ld DE, $4433  ; example value
; Academic example  ld HL, $DCBA  ; example value
; Academic example  exx
; Academic example
; Academic example  call Print_Registers
; Academic example
; Academic example  ;--------------------------------------------
; Academic example  ; Set registers to some test value and print
; Academic example  ; register contents for the second time
; Academic example  ;--------------------------------------------
; Academic example  ld BC, $FEF7  ; example value, different on purpose
; Academic example  ld DE, $3344  ; example value
; Academic example  ld HL, $ABCD  ; example value
; Academic example
; Academic example  exx
; Academic example  ld BC, $FEF7  ; example value
; Academic example  ld DE, $5566  ; example value, different on purpose
; Academic example  ld HL, $DCBA  ; example value
; Academic example  exx
; Academic example
; Academic example  call Print_Registers

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   UTILITIES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Utilities/Print_Registers/Main.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_010.sna", Main
  savebin "bojan_010.bin", Main, $ - Main
