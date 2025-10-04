;----------------------------------------------------------------------------
; Core constants for ZX Spectrum 48K: memory map, screen/attribute layout,
; colors, keyboard ports/keycodes, ROM char addresses, and project addresses
;----------------------------------------------------------------------------
  include "Include/Constants.inc"

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

  ;------------------------------------
  ; Initialize horizontal loop counter
  ;------------------------------------
  ld A, (loop_count)  ; you can't do: ld B, (address)
  ld B, A
  ld C, 0

  ;---------------------------------------------------
  ; Print ten times using subroutine Print_Hor_String
  ;---------------------------------------------------
.loop_hor:

    ld HL, bojan_string    ; HL holds the address of the text to print
    push BC                ; Print_Hor_String clobbers the registers
    call Print_Hor_String
    pop BC

  djnz .loop_hor           ; decrease B and run the loop again

  ;----------------------------------
  ; Initialize vertical loop counter
  ;----------------------------------
  ld B,  0
  ld C, 15

  ;---------------------------------------------------
  ; Print ten times using subroutine Print_Ver_String
  ;---------------------------------------------------
.loop_ver:

    ld HL, bojan_string    ; HL holds the address of the text to print
    push BC                ; Print_Hor_String clobbers the registers
    call Print_Ver_String
    pop BC

    inc C
    ld A, C
    cp 24

  jr nz, .loop_ver           ; decrease B and run the loop again

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Set_Custom_Font.asm"
  include "Shared/Print_Hor_String.asm"
  include "Shared/Print_Ver_String.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

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
  savesna "002_Print_Your_Name_In_Custom_Font.sna", Main
  savebin "002_Print_Your_Name_In_Custom_Font.bin", Main, $ - Main
