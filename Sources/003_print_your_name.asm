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
  ld a, (loopcount)  ; you can't do: ld b, (address)
  ld b, a

Loop:
  push bc
  ld de, bojanstring                 ; address of string
  ld bc, bojanstringend-bojanstring  ; length of string to print
  call ROM_PR_STRING                 ; print the string
  pop bc
  djnz Loop                         ; decrease B and jump if non zero

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;--------------
; Loop counter
;--------------
loopcount:
  defb 10

;-----------------
; String to print
;-----------------
bojanstring:
  defb "Bojan is cool!"
  defb 13                ; new line
bojanstringend equ $

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
