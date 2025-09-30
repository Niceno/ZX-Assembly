;----------------------------------------------------------------------------
; Core constants for ZX Spectrum 48K: memory map, screen/attribute layout,
; colors, keyboard ports/keycodes, ROM char addresses, and project addresses
;----------------------------------------------------------------------------
  include "Include/Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ei       ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
; (Without label "Main", you could have written: SAVESNA "bojan.sna", $8000)
;-------------------------------------------------------------------------------
  savesna "000_Do_Nothing.sna", Main
  savebin "000_Do_Nothing.bin", Main, $ - Main
