  include "spectrum48.inc"

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
;   CODE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main_Sub:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  ld A, 2             ; upper screen is 2
  call ROM_CHAN_OPEN  ; open channel

  ;-------------------------
  ; Initialize loop counter
  ;-------------------------
  ld B, 10

  ;-------------------------------------------------
  ; Print ten times using ROM routine ROM_PR_STRING
  ;-------------------------------------------------
Main_Loop: ; OK, loop inside a subrouinte begins with subroutine's name
  push BC
  ld DE, bojan_string                     ; address of string
  ld BC, bojan_string_end - bojan_string  ; length of string to print
  call ROM_PR_STRING                      ; print the string
  pop BC
  djnz Main_Loop                          ; decrease B and jump if non zero

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;-----------------
; String to print
;-----------------
bojan_string:
  defb "Bojan is cool!"
  defb CHAR_ENTER        ; new line
bojan_string_end equ $

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
; (Without label "Main_Sub", you could have written: SAVESNA "bojan.sna", $8000)
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
