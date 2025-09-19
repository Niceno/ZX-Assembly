;===============================================================================
; Merge_Grid
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a grid over whatever is already on the screen.  It is a helping tool
;   which helps you to check if sprites and tiles are placed correctly
;
; Parameters (passed via registers)
; - none
;
; Clobbers:
; - AF, BC, DE, HL
;-------------------------------------------------------------------------------
Merge_Grid:

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------

  ld B, 0
.loop_rows:  ; from B==0 till B==20  (at 24 breaks)

    ld C, 0
.loop_columns

      ; Grid sprite is 4x4
      ld D, 4
      ld E, 4

      ld HL, grid
      push BC
      call Merge_Udgs_Sprite
      pop BC

      inc C
      inc C
      inc C
      inc C

      ; Check if C is smaller than 32 (CELL_COLS)
      ld A, C
      cp CELL_COLS
    jr c, .loop_columns

    inc B
    inc B
    inc B
    inc B

    ; Check if B is smaller than 24 (CELL_ROWS)
    ld A, B
    cp CELL_ROWS
  jr c, .loop_rows

  ret

  include "Subs/Grid_Cont_Dot.inc"
