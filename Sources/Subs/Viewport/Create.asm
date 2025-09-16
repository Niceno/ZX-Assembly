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
;not now  push BC
;not now  push DE
;not now  ld A, BLACK_INK + MAGENTA_PAPER  ; color not implemented yet
;not now  dec B : dec C                    ; expand the frame to ...
;not now  inc D : inc D : inc E : inc E    ; ... enclose the viewport
;not now  call Draw_Frame
;not now  pop DE
;not now  pop BC

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

