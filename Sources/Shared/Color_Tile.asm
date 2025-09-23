;===============================================================================
; Color_Tile
;-------------------------------------------------------------------------------
; Purpose:
; - Colors a tile defined by upper left and lower right corner
;
; Parameters (passed via registers)
; - A:  color
; - BC: starting row (B) and column (C) - upper left corner
; - DE: dimension of the color tile, number of rows (D) and columns (E)
;
; Calls:
; - Color_Line
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Color_Tile

.loop_rows
    push BC
    push DE
    call Color_Line
    pop DE
    pop BC
    inc B
    dec D
  jr nz, .loop_rows

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "../Shared/Color_Line.asm"
