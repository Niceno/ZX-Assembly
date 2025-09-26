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
;
; Calls:
; - Clamp_A_Tile
; - Color_Tile
;
; Clobbers:
; - AF, DE, HL, IX
;-------------------------------------------------------------------------------
Draw_One_Tile:

  ld A, (HL)  ; this would read the type of tile
  inc HL

.go_again:

  push BC

  ;-------------------------------------------------
  ; Fetch local tile's coordinates (in row/column),
  ; local tiles dimensions (in rows/columns) and
  ; transform them into a range row0,col0,row1,col1
  ;-------------------------------------------------
  ld  A, (HL)  ; read local row
  add A, B     ; add global row to A
  ld  B, A     ; B now holds global row0 for this tile
  inc HL

  ld  A, (HL)  ; read local column
  add A, C     ; add global column to A
  ld  C, A     ; C now holds global col0 for this tile
  inc HL

  ld  A, (HL)  ; read local dim in rows
  add A, B     ; add global row0
  dec A
  ld D, A      ; D now holds global row1 for this tile
  inc HL

  ld A, (HL)   ; read local dim in columns
  add A, C     ; add global col0
  dec A
  ld E, A      ; E now holds global col1
  inc HL

  ;------------------------------------
  ; Load the color and store it in AF'
  ;------------------------------------
  ex AF, AF'
  ld A, (HL)
  inc HL
  ex AF, AF'  ; at this stage, AF' holds the color

  ;------------------------------------------------------
  ; Clamp a tile and return if there is nothing to print
  ;------------------------------------------------------
  call Clamp_A_Tile
  cp 0
  jr z, .skip_print

  ;-------------------------------------------------------
  ; Work out the tile's dimensions and screen coordinates
  ;-------------------------------------------------------
  ld A, D : sub B : inc A : ld D, A  ; calculate number of rows
  ld A, E : sub C : inc A : ld E, A  ; calculate number of columns

  ld IX, hero_world_row  ; transfer world to screen coordinates
  ld A, B : sub (IX+0) : add A, HERO_SCREEN_ROW : ld B, A
  ld A, C : sub (IX+1) : add A, HERO_SCREEN_COL : ld C, A

  ;--------------------------------
  ; Place the tile in the viewport
  ;--------------------------------
  push HL
  ex AF, AF'       ; retreive the color
  call Color_Tile  ; A, BC and DE are the parameters
  ex AF, AF'
  pop HL

.skip_print:

  pop BC

  ld A, (HL)             ; LOCAL TILE
  inc HL
  cp LOCAL_TILE
  jr z, .go_again

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Clamp_A_Tile.asm"

