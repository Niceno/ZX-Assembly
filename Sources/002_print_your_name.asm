  include "spectrum48.inc"

;-------------------------------------------------------------------------------
; Set the architecture you'll be using
;-------------------------------------------------------------------------------
  device zxspectrum48

;-------------------------------------------------------------------------------
; Memory address at which the program will load
;-------------------------------------------------------------------------------
  org MEM_PROGRAM_START


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   CODE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;-------------------------------------------------------------------------------
; Mark the address where the program will start the execution
;-------------------------------------------------------------------------------
Main:
  ld a, 2             ; upper screen
  call ROM_CHAN_OPEN  ; open channel

;-------------------------
; Initialize loop counter
;-------------------------
  ld a, 10 

Loop:
  push af
  ld de, bojanstring                 ; address of string
  ld bc, bojanstringend-bojanstring  ; length of string to print
  call ROM_PR_STRING                 ; print the string
  pop af
  dec a
  jr nz, Loop                        ; jump back if z is not zero

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bojanstring:
  defb "Bojan is cool!"
  defb 13                ; new line
bojanstringend equ $

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
; (Without the label "Main", you could have written: SAVESNA "bojan.sna", $8000)
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
