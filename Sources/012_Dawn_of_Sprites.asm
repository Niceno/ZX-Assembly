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
  ld A, RED_INK + GREEN_PAPER     ; load A with desired color
  ld (MEM_STORE_SCREEN_COLOR), A  ; set the screen colors
  call ROM_CLEAR_SCREEN           ; clear the screen

  ;----------------------
  ; Set the border color
  ;----------------------
  ld A, GREEN_INK              ; load A with desired color
  call ROM_SET_BORDER_COLOR

  ;---------------------
  ; Create the viewport
  ;---------------------
  ld A, WHITE_PAPER + BLUE_INK
  ld B,  0  ; upper left row
  ld C,  0  ; upper left column
  ld D, 21  ; lower right row
  ld E, 27  ; lower right column
  call Create_Viewport

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B,  2  ; upper left row
  ld C,  2  ; upper left column
  ld D,  5  ; lower right row
  ld E,  7  ; lower right column
  ld HL, monster_01
  call Print_Udgs_Tile

  ld A,  RED_INK + YELLOW_PAPER
  ld B,  2  ; upper left row
  ld C,  2  ; upper left column
  ld D,  5  ; lower right row
  ld E,  7  ; lower right column
  call Color_Tile

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B,  3  ; upper left row
  ld C, 13  ; upper left column
  ld D,  4  ; lower right row
  ld E, 14  ; lower right column
  ld HL, circle_q1
  call Print_Udgs_Sprite

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B, 10  ; upper left row
  ld C, 10  ; upper left column
  ld D, 11  ; lower right row
  ld E, 11  ; lower right column
  ld HL, frame_q1
  call Print_Udgs_Sprite

  ;-----------------------------------------------------
  ; Merge the grid over whatever you have on the screen
  ;-----------------------------------------------------
; call Merge_Grid

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Print_Udgs_Character.asm"
  include "Subs/Print_Udgs_Tile.asm"
  include "Subs/Print_Udgs_Sprite_Box.asm"
  include "Subs/Color_Tile.asm"
  include "Subs/Merge_Udgs_Character.asm"
  include "Subs/Merge_Udgs_Sprite_Box.asm"
  include "Subs/Merge_Grid.asm"
  include "Subs/Create_Viewport.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

udgs:
  include "Grid_Cont_Dot.inc"

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

; old: circle_q1: defb $03, $0C, $10, $20, $40, $40, $80, $80
; old: circle_q2: defb $C0, $30, $08, $04, $02, $02, $01, $01
; old: circle_q3: defb $80, $80, $40, $40, $20, $10, $0C, $03
; old: circle_q4: defb $01, $01, $02, $02, $04, $08, $30, $C0

circle_q1: ;
  defb $03, $0F, $13, $33, $4F, $4F, $FF, $7F

circle_q2: ;
  defb $C0, $F0, $F8, $FC, $FE, $FE, $FF, $FE ;

circle_q3: ;
  defb $BF, $CF, $70, $7F, $3F, $1F, $0F, $03 ;

circle_q4: ;
  defb $FD, $F3, $0E, $FE, $FC, $F8, $F0, $C0 ;

; The frame is for the viewport
frame_q1:    defb $FF, $80, $BF, $BF, $B0, $B7, $B7, $B7
frame_q2:    defb $FF, $01, $FD, $FD, $0D, $ED, $ED, $ED
frame_q3:    defb $B7, $B7, $B7, $B0, $BF, $BF, $80, $FF
frame_q4:    defb $ED, $ED, $ED, $0D, $FD, $FD, $01, $FF

frame_up:    defb $FF, $00, $FF, $FF, $00, $FF, $FF, $FF
frame_down:  defb $FF, $FF, $FF, $00, $FF, $FF, $00, $FF
frame_left:  defb $B7, $B7, $B7, $B7, $B7, $B7, $B7, $B7
frame_right: defb $ED, $ED, $ED, $ED, $ED, $ED, $ED, $ED



;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
  savebin "bojan.bin", Main, $ - Main
