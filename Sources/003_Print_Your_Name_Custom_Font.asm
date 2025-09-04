  include "Spectrum_Constants.inc"

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

  ;-----------------
  ; Set custom font
  ;-----------------
  call Set_Custom_Font_Sub

  ld BC, $0000                  ; row and column
  call Set_Text_Coords_Reg_Sub  ; set up up our row/col coords.

  ;----------------------------------------------------------
  ; Store the address of the null-terminated string using HL
  ;----------------------------------------------------------
  ld HL, bojan_string
  ld (text_to_print_addr), HL

  ;-------------------------
  ; Initialize loop counter
  ;-------------------------
  ld A, (loop_count)  ; you can't do: ld b, (address)
  ld B, A

  ;-------------------------------------------------------------------
  ; Print ten times using subroutine Print_Null_Terminated_String_Sub
  ;-------------------------------------------------------------------
Main_Loop:

  ; Set text coordinates for the new value of B (loop counter)
  call Set_Text_Coords_Reg_Sub  ; set up up our row/col coords.

  push BC
  call Print_Null_Terminated_String_Sub
  pop BC

  djnz Main_Loop                ; decrease B and run the loop again

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Set_Custom_Font_Sub.asm"
  include "Subs/Set_Text_Coords_Reg_Sub.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;--------------
; Loop counter
;--------------
loop_count:  defb 10

;---------------------------------
; Null-terminated string to print
;---------------------------------
bojan_string:  defb "Bojan is cool!", 0

;--------------------------------
; Address od the string to print
;--------------------------------
text_to_print_addr:  defw bojan_string    ; store the address of the string

;---------------------------------------------
; Custom font will end up at a custom address
;---------------------------------------------
  org MEM_CUSTOM_FONT_START
custom_font:
  include "../Fonts/Outrunner_Inline.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
