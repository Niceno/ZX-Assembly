  include "Constants.inc"

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

  ;-----------------
  ; Set custom font
  ;-----------------
  call Set_Custom_Font

  ;-------------------------
  ; Initialize loop counter
  ;-------------------------
  ld A, (loop_count)  ; you can't do: ld B, (address)
  ld B, A
  ld C, 0

  ;---------------------------------------------------
  ; Print ten times using subroutine Print_String
  ;---------------------------------------------------
.loop:

    ld HL, bojan_string  ; HL holds the address of the text to print
    push BC              ; Print_String_SUb might clobbers the registers
    call Print_String
    pop BC

  djnz .loop             ; decrease B and run the loop again

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Set_Custom_Font.asm"
  include "Shared/Calculate_Screen_Pixel_Address.asm"
  include "Shared/Print_Character.asm"
  include "Shared/Print_String.asm"

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
bojan_string:  defb "Bojan Niceno", 0

;---------------------------------------------
; Custom font will end up at a custom address
;---------------------------------------------
  org MEM_CUSTOM_FONT_START
custom_font:
  include "../Fonts/Outrunner_Inline.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_003.sna", Main
  savebin "bojan_003.bin", Main, $ - Main
