;===============================================================================
; Viewport_Create
;-------------------------------------------------------------------------------
; Purpose:
; - Creates a viewport
;
; Parameters:
; - BC: upper left row and column coordinate
; - DE: dimensions of the viewport in rows and columns
;-------------------------------------------------------------------------------
Viewport_Create:

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

  ;----------------------
  ;
  ; Draw the frame first
  ;
  ;----------------------
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

