;===============================================================================
; Draw_The_World
;-------------------------------------------------------------------------------
; Purpose:
; - Redraws a portion of the world around the hero.  Nine tiles (3x3) in total
;   stored in world_around_hero_address_table are looped here for redrawal.
;
; Parameters:
; - none, uses global variables to know what to redraw
;
; Global variables used:
; - world_around_hero_address_table
; - world_limits
;
; Calls:
; - Draw_One_Tile
;
; Note:
; - This is how world_around_hero_address_table looks like:
;
;   world_around_hero_address_table:
;   ; type           row  col   definition
;     db WORLD_TILE,   0,   0 : dw $0000
;     ... eight more rows ...
;     db WORLD_END                        ; this marks the end of the world
;-------------------------------------------------------------------------------
Draw_The_World:

  ;------------------------------
  ; Draw all the tiles in a loop
  ;------------------------------
  ld IX, world_around_hero_address_table

.loop_the_world

    ld A, (IX+0)             ; load the first byte
    cp WORLD_END             ; does it mark the end of the world?
    jr z, .end_of_the_world  ; if so, get out of here

    push IX              ; =--> inefficient, try to avoid this

    ; IX+0 would be a type, WORLD_TILE or WORLD_SPRITE, do nothing about it yet
    ld B, (IX+1)  ; starting row
    ld C, (IX+2)  ; starting column
    ld L, (IX+3)  ; address of tile's ...
    ld H, (IX+4)  ; ... definition
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

