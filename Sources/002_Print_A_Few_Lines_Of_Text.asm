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
  ld B, 0
  ld C, 0

  ;---------------------------------------------------
  ; Print ten times using subroutine Print_String
  ;---------------------------------------------------
  ld IX, lines_address_table  ; IX holds the address of lines' addresses
.loop:

    ; Load the line address into HL
    ld L, (IX+0)
    ld H, (IX+1)

    ; Print one line of text
    push BC            ; store the counter; Print_String clobbers the registers
    call Print_String
    pop BC             ; restore the counter

    ; Next table entry
    inc IX
    inc IX

    ; Increase loop count
    inc B
    ld A, B
    cp 10      ; if A is equal to ten, zero flag will be set

  jr nz, .loop  ; if flag is not set, A (and B) didn't reach ten yet

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_String.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

;-----------------------------
; Ten null-terminated strings
;-----------------------------
line_01:  defb "The quick brown fox jumps",    0
line_02:  defb "over the lazy dog tonight.",   0
line_03:  defb "ZX Spectrum lives again.",     0
line_04:  defb "Coding pixels feels so good.", 0
line_05:  defb "Sprites dance on the screen.", 0
line_06:  defb "Old games, new imagination.",  0
line_07:  defb "Press a key to continue...",   0
line_08:  defb "Data and code intertwined.",   0
line_09:  defb "Machine code is poetry.",      0
line_10:  defb "Hello world, in 48K RAM.",     0

; Address table for the lines
lines_address_table:  ; this is a good name, try to stick to it
  defw line_01, line_02, line_03, line_04, line_05
  defw line_06, line_07, line_08, line_09, line_10

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_002_text.sna", Main
  savebin "bojan_002_text.bin", Main, $ - Main
