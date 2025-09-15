;===============================================================================
; Create_Viewport
;-------------------------------------------------------------------------------
; Purpose:
; - Creates a viewport
;
; Parameters:
; - BC: upper left row and column coordinate
; - DE; lower right row and column coordinate
;-------------------------------------------------------------------------------
Create_Viewport:

  push BC
  push DE
  inc D
  inc E
  call Color_Tile
  pop DE
  pop BC

  ;--------------------------
  ; Create upper left corner
  ;--------------------------
  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  ld HL, frame_q1
  call Print_Udgs_Character
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  ;---------------------------
  ; Create upper right corner
  ;---------------------------
  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  ld C, E          ; set the upper left column to be the same as the last (E)
  ld HL, frame_q2
  call Print_Udgs_Character
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  ;--------------------------
  ; Create Lower left corner
  ;--------------------------
  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  ld B, D          ; set the lower right row to be the same as the last (D)
  ld HL, frame_q3
  call Print_Udgs_Character
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  ld B, D          ; set the lower right row to be the same as the last (D)
  ld C, E          ; set the upper left column to be the same as the last (E)
  ld HL, frame_q4
  call Print_Udgs_Character
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  ;----------
  ; Frame up
  ;----------
  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  inc C            ; don't overwrite the corner piece
  ld  D, 1         ; set number of rows to 1
  dec E            ; don't overwrite the corner piece
  ld HL, frame_up
  call Print_Udgs_Tile
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  ;------------
  ; Frame down
  ;------------
  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  ld  B, D         ; start in the last row
  ld D, 1          ; set number of rows to 1
  inc C            ; don't overwrite the corner piece
  dec E            ; don't overwrite the corner piece
  ld HL, frame_down
  call Print_Udgs_Tile
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  ;------------
  ; Frame left
  ;------------
  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  inc B            ; don't overwrite the corner piece
  dec D            ; don't overwrite the corner piece
  ld  E, 1         ; set number of columns to 1
  ld HL, frame_left
  call Print_Udgs_Tile
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  ;-------------
  ; Frame right
  ;-------------
  push BC          ; save the upper left row/column coordinate
  push DE          ; save the lower right row/column coordinate
  inc B            ; don't overwrite the corner piece
  dec D            ; don't overwrite the corner piece
  ld  C, E         ; start at the last column (E)
  ld  E, 1         ; set number of columns to 1
  ld HL, frame_right
  call Print_Udgs_Tile
  pop DE           ; restore the lower right row/column coordinate
  pop BC           ; restore the upper left row/column coordinate

  ret

