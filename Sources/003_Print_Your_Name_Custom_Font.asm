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

  ;-------------------------
  ; Initialize loop counter
  ;-------------------------
  ld A, (loop_count)  ; you can't do: ld B, (address)
  ld B, A
  ld C, 0

  ;---------------------------------------------------
  ; Print ten times using subroutine Print_String_Sub
  ;---------------------------------------------------
Main_Loop:

  ld HL, bojan_string  ; HL holds the address of the text to print
  push BC              ; Print_String_SUb might clobbers the registers
  call Print_String_Sub
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
  include "Subs/Print_Character_Sub.asm"
  include "Subs/Print_String_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

;--------------
; Loop counter
;--------------
loop_count:  defb 10

;---------------------------------
; Null-terminated string to print
;---------------------------------
bojan_string:  defb "Bojan is cool!", 0

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
