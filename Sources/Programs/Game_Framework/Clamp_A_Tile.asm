;===============================================================================
; Clamp_A_Tile
;-------------------------------------------------------------------------------
; Purpose:
; - Clamps a tile to a viewport
;
; Parameters:
; - BC: row0 and col0 (row and column of the uppere left corner)
; - DE: row1 and col1 (row and column of the lowere left corner)
;
; Returns:
; - BC and DE with clamped coordinates
; - A holds 1 if there is something to print, 0 if there is nothing to print
;-------------------------------------------------------------------------------
Clamp_A_Tile:

  ;--------------------------------------------------------------
  ; IX: points to the world limits, which must be in this order:
  ;     - IX+0 =--> world_row_min
  ;     - IX+1 =--> world_col_min
  ;     - IX+2 =--> world_row_max
  ;     - IX+3 =--> world_col_max
  ;--------------------------------------------------------------
  ld IX, world_limits  ; =--> inefficient, try to avoid this

  ;---------------------------------------------------------------
  ; Eliminate tiles which are completelly outside of the viewport
  ;---------------------------------------------------------------

  ; Is row1 (D) smaller than world_row_min
  ld A, D
  cp (IX+0)       ; D - world_row_min
; ret c           ; D < world_row_min =--> not OK, get out
  jr c, .outside  ; D < world_row_min =--> not OK, get out

  ; Is col1 (E) smaller than world_col_min
  ld A, E
  cp (IX+1)       ; E - world_col_min
; ret c           ; E < world_col_min =--> not OK, get out
  jr c, .outside  ; E < world_col_min =--> not OK, get out

  ; Is row0 (B) greater than world_row_max
  ld A, B
  cp (IX+2)    ; B - world_row_max
  jr c, .b_ok  ; B <  world_row_max =--> OK
  jr z, .b_ok  ; B == world_row_max =--> OK
; ret
  jr .outside
.b_ok

  ; Is col0 (C) greater than world_col_max
  ld A, C
  cp (IX+3)    ; C - world_col_max
  jr c, .c_ok  ; C <  world_col_max =--> OK
  jr z, .c_ok  ; C == world_col_max =--> OK
; ret
  jr .outside
.c_ok

  ; If you reached this point, there is at least something to print

  ;--------------------------------
  ; Clamp the tile to the viewport
  ;--------------------------------

  ; Is row0 (B) smaller than world_row_min
  ld A, B
  cp (IX+0)       ; B - world_row_min
  jr nc, .b_fine  ; B > world_row_min =--> OK
  ld B, (IX+0)    ; put world_row_min to B
.b_fine

  ; Is col0 (C) smaller than world_col_min
  ld A, C
  cp (IX+1)       ; C - world_col_min
  jr nc, .c_fine  ; C > world_col_min =--> OK
  ld C, (IX+1)    ; put world_col_min to C
.c_fine

  ; Is row1 (D) greater than world_row_max
  ld A, D
  cp (IX+2)       ; D - world_row_max
  jr c, .d_fine   ; D <  world_row_max =--> OK
  jr z, .d_fine   ; D == world_row_max =--> OK
  ld D, (IX+2)    ; put world_row_max to D
.d_fine

  ; Is col1 (E) greater than world_col_max
  ld A, E
  cp (IX+3)       ; E - world_col_max
  jr c, .e_fine   ; E <  world_col_max =--> OK
  jr z, .e_fine   ; E == world_col_max =--> OK
  ld E, (IX+3)    ; put world_col_max to E
.e_fine

  ;-------------------------------------------
  ; There is something to print, put 1 into A
  ;-------------------------------------------
  ld A, 1

  ret

.outside

  ;-----------------------------------------
  ; There is nothing to print, put 0 into A
  ;-----------------------------------------
  ld A, 0

  ret

