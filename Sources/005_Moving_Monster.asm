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

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld hl, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), hl  ; set up UDG system variable.

  ;---------------------------------------------
  ; Initialize text row in which you will start
  ;---------------------------------------------
  ld A, 21          ; row 21 = bottom of screen.
  ld (text_row), A  ; set initial text row

  ; --------------
  ; Set the color
  ; --------------
  ld A, RED_INK + CYAN_PAPER      ; load A with desired color
  ld (MEM_STORE_SCREEN_COLOR), A  ; set the screen colors
  call ROM_CLEAR_SCREEN           ; clear the screen

  ;---------------------
  ; Move the monster up
  ;---------------------
Main_Loop:
  call Set_Text_Coords_Sub  ; set up our row/column coords

  ; Print monster
  ld A, $90          ; want a monster (UDG) here
  rst ROM_PRINT_A_1  ; display it

  call Delay_Sub     ; want a delay

  ; Delete the monster (print space over it)
  call Set_Text_Coords_Sub  ; set up our row/column coords
  ld A, CHAR_SPACE          ; ASCII code for space
  rst ROM_PRINT_A_1         ; delete old monster

  ; Decrease text row -> move monster position up
  ld HL, text_row   ; vertical position
  dec (HL)          ; move it up one line
  ld A, (HL)        ; where is it now?
  cp 255            ; past top of screen yet?
  jr nz, Main_Loop  ; no, carry on

  ret  ; end of the main program

;===============================================================================
; Delay subroutine
;-------------------------------------------------------------------------------
Delay_Sub:
  ei         ; enable interrupts, otherwise it gets stuck
             ; Speccy creates ~ 50 interruts per second, or each 0.02 seconds
  ld B, 10   ; length of delay; translates to roughly 0.2 s

Delay_Loop:
  halt             ; wait for an interrupt
  djnz Delay_Loop  ; loop

  ret

;===============================================================================
; Set coordinates subroutine
;
; Uses "variables" text_row and text_column to set printing position
;-------------------------------------------------------------------------------
Set_Text_Coords_Sub:

  ld A, CHAR_AT_CONTROL  ; ASCII control code for "at"
                         ; should be followed by row and column entries
  rst ROM_PRINT_A_1      ; "print" it

  ld A, (text_row)       ; row
  rst ROM_PRINT_A_1      ; "print" it

  ld A, (text_column)    ; column
  rst ROM_PRINT_A_1      ; "print" it

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_row:
  defb 0

text_column:
  defb 15

udgs:

; The 8x8 sprites which follow, were created with the command:
; python.exe .\convert_sprite_8x8.py .\[name].8x8 in the directory Figures
ghost_01: ; starts at $90
  defb $3C, $7E, $DB, $99, $FF, $FF, $DB, $DB

human_01: ; starts at $91
  defb $18, $3C, $18, $FF, $18, $3C, $24, $66

monster_01: ; starts at $92
  defb $99, $BD, $5A, $7E, $42, $3C, $DB, $81

monster_02: ; starts at $93
  defb $24, $3C, $3C, $5A, $BD, $3C, $66, $42

monster_03: ; starts at $94
  defb $24, $7E, $FF, $DB, $7E, $42, $BD, $81

monster_04: ; starts at $95
  defb $42, $81, $BD, $5A, $66, $3C, $66, $A5

arrow_up: ; starts at $96
  defb $18, $24, $42, $C3, $24, $24, $24, $3C

arrow_down: ; starts at $97
  defb $3C, $24, $24, $24, $C3, $42, $24, $18

arrow_left: ; starts at $98
  defb $10, $30, $4F, $81, $81, $4F, $30, $10

arrow_right: ; starts at $99
  defb $08, $0C, $F2, $81, $81, $F2, $0C, $08

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
