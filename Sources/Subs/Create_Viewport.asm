;===============================================================================
; Create_Viewport
;-------------------------------------------------------------------------------
; Purpose:
; - Creates a viewport
;
; Parameters:
; - BC: upper left row and column coordinate
; - DE: dimensions of the viewport in rows and columns
;-------------------------------------------------------------------------------
Create_Viewport:

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

  ;--------------------------
  ; Create upper left corner
  ;--------------------------
  push BC
  push DE
  ld HL, frame_q1
  call Print_Udgs_Character
  pop DE
  pop BC

  ;---------------------------
  ; Create upper right corner
  ;---------------------------
  push BC
  push DE
  ld A, C : add E : dec A : ld C, A  ; adjust column (C)
  ld HL, frame_q2
  call Print_Udgs_Character
  pop DE
  pop BC

  ;--------------------------
  ; Create lower left corner
  ;--------------------------
  push BC
  push DE
  ld A, B : add D : dec A : ld B, A  ; adjust row (B)
  ld HL, frame_q3
  call Print_Udgs_Character
  pop DE
  pop BC

  ;---------------------------
  ; Create lower right corner
  ;---------------------------
  push BC
  push DE
  ld A, C : add E : dec A : ld C, A  ; adjust column (C)
  ld A, B : add D : dec A : ld B, A  ; adjust row (B)
  ld HL, frame_q4
  call Print_Udgs_Character
  pop DE
  pop BC

  ;----------
  ; Frame up
  ;----------
  push BC
  push DE
  inc C
  dec E            ; don't overwrite the corner piece
  dec E            ; don't overwrite the corner piece
  ld HL, frame_up
  call Print_Udgs_Tile_Line
  pop DE
  pop BC

  ;------------
  ; Frame down
  ;------------
  push BC
  push DE
  ld A, B : add D : dec A : ld B, A  ; adjust row (B)
  inc C
  dec E                              ; don't overwrite the corner piece
  dec E                              ; don't overwrite the corner piece
  ld HL, frame_down
  call Print_Udgs_Tile_Line
  pop DE
  pop BC

  ;------------
  ; Frame left
  ;------------
  push BC
  push DE
  inc B
  dec D              ; don't overwrite the corner piece
  dec D              ; don't overwrite the corner piece
  ld  E, 1           ; set number of columns to 1
  ld HL, frame_left
  call Print_Udgs_Tile
  pop DE
  pop BC

  ;-------------
  ; Frame right
  ;-------------
  push BC
  push DE
  inc B                              ; don't overwrite the corner piece
  ld A, C : add E : dec A : ld C, A  ; adjust column (C)
  dec D                              ; don't overwrite the corner piece
  dec D                              ; don't overwrite the corner piece
  ld  E, 1                           ; set number of columns to 1
  ld HL, frame_right
  call Print_Udgs_Tile
  pop DE
  pop BC

  ;------------------------------------
  ;
  ; Store viewport data for attributes
  ;
  ;------------------------------------

  ; Avoid the frame, store only inside the frame
  inc B : inc C  ; row and column should increase ...
  dec D : dec D  ; and dimensions decrease ...
  dec E : dec E  ; ... by two

  ; Store dimension as two bytes.  Although it seems an overkill
  ; here, it makes them easier to read by register pairs later
  ld IX, viewport_attribute_metadata
  ld (IX+0), D  ; number of rows inside the viewport
  ld (IX+1), 0
  ld (IX+2), E  ; number of columns inside the viewport
  ld (IX+3), 0

  ld IX, viewport_attribute_addresses

.loop_rows
    push BC
    push DE
    call Calculate_Screen_Attribute_Address  ; will store address in HL
    pop DE
    pop BC

    ; Store the address from HL
    ld(IX+0), L
    ld(IX+1), H

    ; Increase the row
    inc B

    ; Point to the next storage place
    inc IX
    inc IX

    dec D
  jr nz, .loop_rows

  ret


viewport_attribute_metadata:
  defw  $0000      ; + 0 number of rows
  defw  $0000      ; + 2 number of columns
viewport_attribute_addresses:
  defw  $0000      ; + 0
  defw  $0000      ; + 2 second row in the viewport
  defw  $0000      ; + 4 third
  defw  $0000      ; + 6
  defw  $0000      ; + 8
  defw  $0000      ; +10
  defw  $0000      ; +12
  defw  $0000      ; +14
  defw  $0000      ; +16
  defw  $0000      ; +18
  defw  $0000      ; +20
  defw  $0000      ; +22
  defw  $0000      ; +24
  defw  $0000      ; +26
  defw  $0000      ; +28
  defw  $0000      ; +30
  defw  $0000      ; +32
  defw  $0000      ; +34
  defw  $0000      ; +36
  defw  $0000      ; +38
  defw  $0000      ; +40
  defw  $0000      ; +42
  defw  $0000      ; +44
  defw  $0000      ; +46

