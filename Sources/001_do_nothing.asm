  include "spectrum48.inc"

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
Main_Sub:  ; If the adress is that of a subroutine, end it up with _Sub suffix
  ret

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
; (Without label "Main_Sub", you could have written: SAVESNA "bojan.sna", $8000)
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
