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

  ;-------------------------
  ; Initialize loop counter
  ;-------------------------
  ld B, 10
  ld C,  0

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
  include "Shared/Calculate_Screen_Pixel_Address.asm"
  include "Shared/Print_Character.asm"
  include "Shared/Print_String.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

;---------------------------------
; Null-terminated string to print
;---------------------------------
bojan_string:  defb "Bojan Niceno", 0

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_002_name.sna", Main
  savebin "bojan_002_name.bin", Main, $ - Main
