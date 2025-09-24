;===============================================================================
; Draw_One_Tile
;-------------------------------------------------------------------------------
; Purpose:
; - Draws one tile in the viewport.  But, it does it with prudence.  Tiles
;   which are outside of the viewport are skipped, and the tiles which are
;   only partially in the viewport are clamped.
;
; Parameters:
; - BC: holds row and column
; - HL: points to the tile
; - IX: points to the world limits, which must be in this order:
;       - IX+0 =--> world_row_min
;       - IX+1 =--> world_col_min
;       - IX+2 =--> world_row_max
;       - IX+3 =--> world_col_max
;
; Calls:
; - Color_Tile
;
; Clobbers:
; - AF, DE, HL, IX
;-------------------------------------------------------------------------------
Draw_One_Tile:

  ;--------------------------------------
  ; Fetch tile's dimensions, add them to
  ; row0 and col0 and store in D and E
  ;--------------------------------------
  ld A, (HL) : add A, B : dec A : ld D, A : inc HL
  ld A, (HL) : add A, C : dec A : ld E, A : inc HL

  ;---------------------------------------------------------------
  ; Eliminate tiles which are completelly outside of the viewport
  ;---------------------------------------------------------------

  ; Is row1 (D) smaller than world_row_min
  ld A, D
  cp (IX+0)  ; D - world_row_min
  ret c      ; D < world_row_min =--> not OK, get out

  ; Is col1 (E) smaller than world_col_min
  ld A, E
  cp (IX+1)  ; E - world_col_min
  ret c      ; E < world_col_min =--> not OK, get out

  ; Is row0 (B) greater than world_row_max
  ld A, B
  cp (IX+2)    ; B - world_row_max
  jr c, .b_ok  ; B <  world_row_max =--> OK
  jr z, .b_ok  ; B == world_row_max =--> OK
  ret
.b_ok

  ; Is col0 (C) greater than world_col_max
  ld A, C
  cp (IX+3)    ; C - world_col_max
  jr c, .c_ok  ; C <  world_col_max =--> OK
  jr z, .c_ok  ; C == world_col_max =--> OK
  ret
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

  ;---------------------------------
  ; Work out the tile's dimensions and screen coordinates
  ;---------------------------------
  ld A, D : sub B : inc A : ld D, A  ; calculate number of rows
  ld A, E : sub C : inc A : ld E, A  ; calculate number of columns
  ld IX, hero_world_row  ; transfer world to screen coordinates
  ld A, B : sub (IX+0) : add A, HERO_SCREEN_ROW : ld B, A
  ld A, C : sub (IX+1) : add A, HERO_SCREEN_COL : ld C, A

  ;----------------
  ; Load the color
  ;----------------
  ld A, (HL)

  ;--------------------------------
  ; Place the tile in the viewport
  ;--------------------------------
  call Color_Tile  ; A, BC and DE are the parameters

  ret

