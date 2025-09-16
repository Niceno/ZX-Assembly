  include "Spectrum_Constants.inc"

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
  savesna "bojan_001.sna", Main
  savebin "bojan_001.bin", Main, $ - Main
