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
;   MAIN SUBROUTINE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main_Sub:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen_Sub

  ld A, 0
  ld (text_column), A       ; store column coordinate
  ld A, 0
  ld (text_row), A          ; store row coordinate
  call Set_Text_Coords_Sub  ; set up up our row/col coords.

  ;----------------------------------------------------------
  ; Store the address of the null-terminated string using HL
  ;----------------------------------------------------------
  ld HL, bojan_string
  ld (text_to_print_addr), HL

  ;-------------------------
  ; Initialize loop counter
  ;-------------------------
  ld B, 10

  ;-------------------------------------------------------------------
  ; Print ten times using subroutine Print_Null_Terminated_String_Sub
  ;-------------------------------------------------------------------
Main_Loop:

  ; Set text coordinates for the new value of B (loop counter)
  ld A, 0
  ld (text_column), A       ; store column coordinate
  ld A, B
  dec A                     ; go from 9 to 0 instead of 10 to 1
  ld (text_row), A          ; store row coordinate
  call Set_Text_Coords_Sub  ; set up up our row/col coords.

  call Print_Null_Terminated_String_Sub

  djnz Main_Loop            ; decrease B and run the loop again

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Set_Text_Coords_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;---------------------------------
; Null-terminated string to print
;---------------------------------
bojan_string: defb "Bojan is cool!", 0

;--------------------------------
; Address od the string to print
;--------------------------------
text_to_print_addr: defw bojan_string    ; store the address of the string

text_row:     defb  0
text_column:  defb 15

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
; (Without label "Main_Sub", you could have written: SAVESNA "bojan.sna", $8000)
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
