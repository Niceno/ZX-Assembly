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
;   MAIN PROGRAM
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld HL, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), HL  ; set up UDG system variable.

  ;---------------
  ; Set the color
  ;---------------
  ld A, RED_INK + CYAN_PAPER      ; load A with desired color
  ld (MEM_STORE_SCREEN_COLOR), A  ; set the screen colors
  call ROM_CLEAR_SCREEN           ; clear the screen

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld BC, $0101
  ld DE, $0406
  ld HL, monster_01
  call Print_Udgs_Tile

  ld A,  BLUE_INK + YELLOW_PAPER
  ld BC, $0101
  ld DE, $0406
  ld HL, monster_01
  call Color_Tile

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld BC, $010A
  ld DE, $020B
  ld HL, circle_q1
  call Print_Udgs_Sprite

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Print_Udgs_Character.asm"
  include "Subs/Print_Udgs_Tile_Box.asm"
  include "Subs/Print_Udgs_Sprite_Box.asm"
  include "Subs/Color_Tile_Box.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

udgs:

; The 8x8 sprites which follow, were created with the command:
; python.exe .\convert_sprite_8x8.py .\[name].8x8 in the directory Figures
ghost_01:        defb $3C, $7E, $DB, $99, $FF, $FF, $DB, $DB
human_01:        defb $18, $3C, $18, $FF, $18, $3C, $24, $66
monster_01:      defb $99, $BD, $5A, $7E, $42, $3C, $DB, $81
monster_02:      defb $24, $3C, $3C, $5A, $BD, $3C, $66, $42
monster_03:      defb $24, $7E, $FF, $DB, $7E, $42, $BD, $81
monster_04:      defb $42, $81, $BD, $5A, $66, $3C, $66, $A5
arrow_up:        defb $18, $24, $42, $C3, $24, $24, $24, $3C
arrow_down:      defb $3C, $24, $24, $24, $C3, $42, $24, $18
arrow_left:      defb $10, $30, $4F, $81, $81, $4F, $30, $10
arrow_right:     defb $08, $0C, $F2, $81, $81, $F2, $0C, $08
space_to_print:  defb $00, $00, $00, $00, $00, $00, $00, $00

circle_q1: defb $03, $0C, $10, $20, $40, $40, $80, $80
circle_q2: defb $C0, $30, $08, $04, $02, $02, $01, $01
circle_q3: defb $80, $80, $40, $40, $20, $10, $0C, $03
circle_q4: defb $01, $01, $02, $02, $04, $08, $30, $C0



;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
  savebin "bojan.bin", Main, $ - Main
