;===============================================================================
; Draw_The_World
;-------------------------------------------------------------------------------
; Purpose:
; - Redraws the world.  Depending on the values in global variable world_limits
;   it may redraw the whole world, or just one line which dissappears from the
;   screen during scrolling.
;
; Parameters:
; - world_address_table global variable is used
;-------------------------------------------------------------------------------
Draw_The_World:

  ;------------------------------
  ; Draw all the tiles in a loop
  ;------------------------------
  ld IX, world_address_table
.loop_the_world

    ld A,(IX+0)              ; load the first byte
    cp WORLD_END             ; does it mark the end of the world?
    jr z, .end_of_the_world  ; if so, get out of here

    push IX              ; =--> inefficient, try to avoid this

    ; IX+0 would be a type, WORLD_TILE or WORLD_SPRITE, do nothing about it yet
    ld B, (IX+1)  ; starting row
    ld C, (IX+2)  ; starting column
    ld L, (IX+3)
    ld H, (IX+4)
    ld IX, world_limits  ; =--> inefficient, try to avoid this
    call Draw_One_Tile

    pop IX               ; =--> inefficient, try to avoid this

    inc IX  ; type (WORLD_END, WORLD_TILE or WORLD_SPRITE)
    inc IX  ; row
    inc IX  ; col
    inc IX
    inc IX

  jr .loop_the_world

.end_of_the_world

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Draw_One_Tile.asm"

