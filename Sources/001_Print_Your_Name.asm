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

  ;------------------------------------
  ; Initialize horizontal loop counter
  ;------------------------------------
  ld B, 10
  ld C,  0

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
  include "Shared/Print_Hor_String.asm"
  include "Shared/Print_Ver_String.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

;---------------------------------
; Null-terminated string to print
;---------------------------------
bojan_string:  defb "Bojan Niceno", 0

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "001_Print_Your_Name.sna", Main
  savebin "001_Print_Your_Name.bin", Main, $ - Main
