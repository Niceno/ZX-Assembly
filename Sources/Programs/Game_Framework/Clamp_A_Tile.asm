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
; Global parameters used:
; - world_limits
;
; Clobbers (I mean, these are the return values):
; - AF, BC, DE,
;
; Returns:
; - BC and DE with clamped coordinates
; - A holds 1 if there is something to print, 0 if there is nothing to print
;-------------------------------------------------------------------------------
Clamp_A_Tile:

  push HL

  ;--------------------------------------------------------------
  ; HL: points to the world limits, which must be in this order:
  ;     - HL+0 =--> world_row_min
  ;     - HL+1 =--> world_col_min
  ;     - HL+2 =--> world_row_max
  ;     - HL+3 =--> world_col_max
  ;--------------------------------------------------------------
  ld HL, world_limits  ; =--> inefficient, try to avoid this

  ;---------------------------------------------------------------
  ; Eliminate tiles which are completelly outside of the viewport
  ;---------------------------------------------------------------

  ; Is row1 (D) smaller than world_row_min
  ld A, D
  cp (HL)         ; D - world_row_min
  jr c, .outside  ; D < world_row_min =--> not OK, get out
  inc HL

  ; Is col1 (E) smaller than world_col_min
  ld A, E
  cp (HL)         ; E - world_col_min
  jr c, .outside  ; E < world_col_min =--> not OK, get out
  inc HL

  ; Is row0 (B) greater than world_row_max
  ld A, B
  cp (HL)      ; B - world_row_max
  jr c, .b_ok  ; B <  world_row_max =--> OK
  jr z, .b_ok  ; B == world_row_max =--> OK
  jr .outside
.b_ok
  inc HL

  ; Is col0 (C) greater than world_col_max
  ld A, C
  cp (HL)      ; C - world_col_max
  jr c, .c_ok  ; C <  world_col_max =--> OK
  jr z, .c_ok  ; C == world_col_max =--> OK
  jr .outside
.c_ok
  inc HL       ; not needed?

  ;---------------------------------------------------------
  ; If you reached this point, there is at least something
  ; to print, so restore the HL and start with clamping
  ;---------------------------------------------------------
  ld HL, world_limits  ; =--> inefficient, try to avoid this

  ;--------------------------------
  ; Clamp the tile to the viewport
  ;--------------------------------

  ; Is row0 (B) smaller than world_row_min
  ld A, B
  cp (HL)         ; B - world_row_min
  jr nc, .b_fine  ; B > world_row_min =--> OK
  ld B, (HL)      ; put world_row_min to B
.b_fine
  inc HL

  ; Is col0 (C) smaller than world_col_min
  ld A, C
  cp (HL)         ; C - world_col_min
  jr nc, .c_fine  ; C > world_col_min =--> OK
  ld C, (HL)      ; put world_col_min to C
.c_fine
  inc HL

  ; Is row1 (D) greater than world_row_max
  ld A, D
  cp (HL)         ; D - world_row_max
  jr c, .d_fine   ; D <  world_row_max =--> OK
  jr z, .d_fine   ; D == world_row_max =--> OK
  ld D, (HL)      ; put world_row_max to D
.d_fine
  inc HL

  ; Is col1 (E) greater than world_col_max
  ld A, E
  cp (HL)         ; E - world_col_max
  jr c, .e_fine   ; E <  world_col_max =--> OK
  jr z, .e_fine   ; E == world_col_max =--> OK
  ld E, (HL)      ; put world_col_max to E
.e_fine
  inc HL          ; not needed?

  ;-------------------------------------------
  ; There is something to print, put 1 into A
  ;-------------------------------------------
  ld A, 1

  pop HL

  ret

.outside

  ;-----------------------------------------
  ; There is nothing to print, put 0 into A
  ;-----------------------------------------
  ld A, 0

  pop HL

  ret

