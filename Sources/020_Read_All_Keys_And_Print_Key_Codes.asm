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
;   MAIN PROGRAM
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ;-----------------------------------
  ; Color the box for the pressed key
  ;-----------------------------------
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld B, 11                      ; row
  ld C, 15                      ; column
  ld D,  3                      ; length
  ld E,  3                      ; length
  call Color_Tile               ; A, BC and DE are parameters

  ;--------------------------------------
  ; Print DE register names and contents
  ; as well as the text for unique code
  ;--------------------------------------
  ld B,  0           ; row
  ld C,  0           ; column
  ld HL, reg_d
  call Print_String  ; HL & BC are the parameters
  ld B,  1           ; row
  ld C,  0           ; column
  ld HL, reg_e
  call Print_String  ; HL & BC are the parameter
  ld B,  2           ; row
  ld C,  0           ; column
  ld HL, unique_code
  call Print_String  ; HL & BC are the parameter

reg_d:        defb "D (key row):", 0
reg_e:        defb "E (key bit):", 0
unique_code:  defb "Unique code:", 0

  ;---------------------------------
  ; Color the box for the registers
  ;---------------------------------
  ld B,  0  ; row
  ld C,  0  ; column
  ld D,  3
  ld E, 15
  ld A, BLUE_INK + CYAN_PAPER
  call Color_Tile

  ;--------------------------------
  ;
  ; Infinite loop for reading keys
  ;
  ;--------------------------------
.outer_infinite_loop:

  call Browse_Key_Rows             ; outputs unique code in A, and flag in C
  bit 0, C                         ; was a key pressed?
  jr nz, .process_the_pressed_key  ; if a key was pressed process it

  jr .outer_infinite_loop          ; if not pressed, repeat loop

  ;----------------------------
  ;
  ; Print the proper character
  ;
  ;----------------------------
.process_the_pressed_key:

    ; Place the unique key in HL (for printing) and on stack
    ld H, 0
    ld L, A
    push HL  ; store for later printing

    ; Print the unique key (stored in HL for printing)
    ld B,  2                  ; row
    ld C, 12                  ; column
    push DE                   ; have to store them for printing below
    call Print_08_Bit_Number
    pop DE

    ;-----------------------------
    ; Print the register contents
    ;  (This is just for kicks)
    ;-----------------------------
    ld B,  0                  ; row
    ld C, 12                  ; column
    ld H,  0                  ; number to print
    ld L,  D                  ; number to print
    push DE                   ; still for printing
    call Print_08_Bit_Number
    pop DE
    ld B,  1                  ; row
    ld C, 12                  ; column
    ld H,  0                  ; number to print
    ld L,  E                  ; number to print
    call Print_08_Bit_Number

    ;---------------------
    ; Print the character
    ;---------------------
    pop DE  ; unique key; pushed as HL above

    ; Set HL to point to the right character
    ld  IX, key_glyphs_address_table
    add IX, DE
    add IX, DE

    ; Load HL with the correct character to print
    ld L, (IX+0)
    ld H, (IX+1)

    ld B, 12      ; row
    ld C, 16      ; column
    call Print_Udgs_Character

  jp .outer_infinite_loop

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Color_Tile.asm"
  include "Shared/Print_String.asm"
  include "Shared/Print_08_Bit_Number.asm"
  include "Shared/Browse_Key_Rows.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "020_Read_All_Keys_And_Print_Key_Codes.sna", Main
  savebin "020_Read_All_Keys_And_Print_Key_Codes.bin", Main, $ - Main
