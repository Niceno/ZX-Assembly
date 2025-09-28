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
; - Color_Hor_Line
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Color_Tile

  ex AF, AF'  ; store the color

  ;-----------------------
  ; Is the tile vertical?
  ;-----------------------
  ld A, E  ; check the number of columns
  xor 1    ; is it 1?
  jr nz, .the_tile_is_not_vertical  ; E is not one

  ; Yes it is, restore AF, draw a vertical line and get out of here
  ex AF, AF'
  call Color_Ver_Line
  ret

.the_tile_is_not_vertical

  ;-------------------------
  ; Is the tile horizontal?
  ;-------------------------
  ld A, D  ; check the number of rows
  xor 1    ; is it 1?
  jr nz, .the_tile_is_not_horizontal  ; D is not one

  ; Yes it is, restore AF, draw a horizontal line and get out of here
  ex AF, AF'
  call Color_Hor_Line
  ret

.the_tile_is_not_horizontal

  ;-----------------------------------------------
  ; If you are here, the tile is neither vertical
  ; nor horizontal, but general.  Restore the AF
  ; and run a full loop through horizontal lines.
  ;-----------------------------------------------

  ex AF, AF'

  call Flicker_Border
.loop_rows
    push BC
    push DE
    call Color_Hor_Line
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
  include "Shared/Flicker_Border.asm"
  include "Shared/Color_Hor_Line.asm"
  include "Shared/Color_Ver_Line.asm"

