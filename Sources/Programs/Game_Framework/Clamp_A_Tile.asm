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

  ;--------------------------------------------------
  ; Work out from which direction you have to redraw
  ;--------------------------------------------------

  ; Assume you have to redraw all (although it happens only once)
  exx
  ld A, (hero_world_row) : add A, WORLD_ROW_MIN_OFFSET : ld B, A  ; former "world row min"
  ld A, (hero_world_col) : add A, WORLD_COL_MIN_OFFSET : ld C, A  ; former "world col min"
  ld A, (hero_world_row) : add A, WORLD_ROW_MAX_OFFSET : ld D, A  ; former "world row max"
  ld A, (hero_world_col) : add A, WORLD_COL_MAX_OFFSET : ld E, A  ; former "world col max"
  exx

  ld A, (world_redraw)

  ; North
  cp REDRAW_N
  jr nz, .dont_redraw_north

    ld A, (hero_world_row)
    add A, WORLD_ROW_MIN_OFFSET  ; work out "world row min"
    exx
    ld B, A  ; store "world row min";      (B')
    ld D, A  ; set "world row max" = min;  (D' = B')
    exx
    jr .draw_now

.dont_redraw_north

  ; East
  cp REDRAW_E
  jr nz, .dont_redraw_east

    ld A, (hero_world_col)
    add A, WORLD_COL_MAX_OFFSET  ; work out "world col max"
    exx
    ld E, A  ; store "world col max";      (E')
    ld C, A  ; set "world col min" = max;  (C' = E')
    exx
    jr .draw_now

.dont_redraw_east

  ; South
  cp REDRAW_S
  jr nz, .dont_redraw_south

    ld A, (hero_world_row)
    add A, WORLD_ROW_MAX_OFFSET  ; work out "world row max"
    exx
    ld D, A  ; store "world row max";      (D')
    ld B, A  ; set "world row min" = max;  (B' = D')
    exx
    jr .draw_now

.dont_redraw_south

  ; West
  cp REDRAW_W
  jr nz, .dont_redraw_west

    ld A, (hero_world_col)
    add A, WORLD_COL_MIN_OFFSET  ; work out "world col min"
    exx
    ld C, A  ; store "world col min";      (C')
    ld E, A  ; set "world col max" = min;  (E' = C')
    exx
    jr .draw_now

.dont_redraw_west

.draw_now

  ;---------------------------------------------------------------
  ; Eliminate tiles which are completelly outside of the viewport
  ;---------------------------------------------------------------

  ; Is row1 (D) smaller than "world row min"
  ld A, D
  exx
  cp B            ; D - "world row min" (B')
  exx
  jr c, .outside  ; D < "world row min" =--> not OK, get out

  ; Is col1 (E) smaller than "world col min"
  ld A, E
  exx
  cp C            ; E - "world col min" (C')
  exx
  jr c, .outside  ; E < "world col min" =--> not OK, get out

  ; Is row0 (B) greater than "world row max"
  ld A, B
  exx
  cp D         ; B - "world row max" (D')
  exx
  jr c, .b_ok  ; B <  "world row max" =--> OK
  jr z, .b_ok  ; B == "world row max" =--> OK
  jr .outside
.b_ok

  ; Is col0 (C) greater than "world col max"
  ld A, C
  exx
  cp E         ; C - "world col max" (E')
  exx
  jr c, .c_ok  ; C <  "world col max" =--> OK
  jr z, .c_ok  ; C == "world col max" =--> OK
  jr .outside
.c_ok

  ;-----------------------------------------------------------------
  ; If you reached this point, there is at least something to print
  ;-----------------------------------------------------------------
  ; - B' =--> "world row min"
  ; - C' =--> "world col min"
  ; - D' =--> "world row max"
  ; - E' =--> "world col max"
  ;--------------------------------------------------------------

  ;--------------------------------
  ; Clamp the tile to the viewport
  ;--------------------------------

  ; Is row0 (B) smaller than "world row min"
  ld A, B
  exx
  cp B            ; B - "world row min" (B')
  ld A, B         ; place B' into A
  exx
  jr nc, .b_fine  ; B > "world row min" (B') =--> OK
  ld B, A         ; put "world row min" (B') to B
.b_fine

  ; Is col0 (C) smaller than "world col min"
  ld A, C
  exx
  cp C            ; C - "world col min" (C')
  ld A, C         ; place C' into A
  exx
  jr nc, .c_fine  ; C > "world col min" (C') =--> OK
  ld C, A         ; put "world col min" (C') to C
.c_fine

  ; Is row1 (D) greater than "world row max"
  ld A, D
  exx
  cp D            ; D - "world row max" (D')
  ld A, D         ; place D' into A
  exx
  jr c, .d_fine   ; D <  "world row max" (D') =--> OK
  jr z, .d_fine   ; D == "world row max" (D') =--> OK
  ld D, A         ; put "world row max" (D') to D
.d_fine

  ; Is col1 (E) greater than "world col max"
  ld A, E
  exx
  cp E            ; E - "world col max" (E')
  ld A, E         ; place E' into A
  exx
  jr c, .e_fine   ; E <  "world col max" (E') =--> OK
  jr z, .e_fine   ; E == "world col max" (E') =--> OK
  ld E, A         ; put "world col max" (E') to E
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

