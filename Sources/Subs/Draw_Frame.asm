Draw_Frame:
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
  call Print_Udgs_Line_Tile
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
  call Print_Udgs_Line_Tile
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

  ret

