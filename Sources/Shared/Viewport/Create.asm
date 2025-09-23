;===============================================================================
; Viewport_Create
;-------------------------------------------------------------------------------
; Purpose:
; - Creates a viewport
;
; Parameters:
; - Global constants CELL_ROW_VIEW_MIN, CELL_ROW_ ... CELL_COL_VIEV_MAX
;   are used to define the Viewport.  This is introduced for the sake of
;   efficiency, the dimensions of the viewport are practically hard coded.
;-------------------------------------------------------------------------------
Viewport_Create:

  ;-------------------------------
  ;   CELL_ROW_VIEW_MIN
  ;   |         CELL_ROW_VIEW_MAX
  ;   |         |
  ; 0 1 2 3 4 5 6 7 8 9
  ;-------------------------------
  ld B, CELL_ROW_VIEW_MIN                          ; row
  ld C, CELL_COL_VIEW_MIN                          ; column
  ld D, CELL_ROW_VIEW_MAX - CELL_ROW_VIEW_MIN + 1  ; viewport dimension in rows
  ld E, CELL_COL_VIEW_MAX - CELL_COL_VIEW_MIN + 1  ; viewport dimension in cols

  ;--------------------
  ;
  ; Color the viewport
  ;
  ;--------------------
  push BC
  push DE
  call Color_Tile
  pop DE
  pop BC

  ;--------------------------------------------
  ;
  ; Draw the frame first - if it fits, that is
  ;
  ;--------------------------------------------
  ld A, B : cp 0 : jr z, .skip_frame  ; if B (row) is zero, skip the frame
  ld A, C : cp 0 : jr z, .skip_frame  ; if C (column) is zero, skip the frame
  ld A, B : add D : dec A : cp CELL_ROWS - 1
  jr nc, .skip_frame                  ; if A > 23, skip frame
  ld A, C : add E : dec A : cp CELL_COLS - 1
  jr nc, .skip_frame                  ; if A > 31, skip frame

  push BC
  push DE
; ld A, BLACK_INK + MAGENTA_PAPER  ; color not implemented yet
  dec B : dec C                    ; expand the frame to ...
  inc D : inc D : inc E : inc E    ; ... enclose the viewport
  call Draw_Frame
  pop DE
  pop BC

.skip_frame

  ;------------------------------------
  ;
  ; Store viewport data for attributes
  ;
  ;------------------------------------
  push BC
  push DE
  call Viewport_Store_Data_For_Attributes
  pop DE
  pop BC

  ;--------------------------------
  ;
  ; Store viewport data for pixels
  ;
  ;--------------------------------
  push BC
  push DE
  call Viewport_Store_Data_For_Pixels
  pop DE
  pop BC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Color_Tile.asm"
  include "Shared/Draw_Frame.asm"
  include "Shared/Viewport/Store_Data_For_Attributes.asm"
  include "Shared/Viewport/Store_Data_For_Pixels.asm"

