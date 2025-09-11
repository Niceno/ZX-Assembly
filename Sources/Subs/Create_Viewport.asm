;===============================================================================
; Create_Viewport
;-------------------------------------------------------------------------------
Create_Viewport:

  push BC
  push DE
  call Color_Tile
  pop DE
  pop BC

  ; create upper left corner
  push BC
  push DE
  ld HL, frame_q1
  call Print_Udgs_Character
  pop DE
  pop BC

  ; create upper right corner
  push BC
  push DE
  ld C, E
  ld HL, frame_q2
  call Print_Udgs_Character
  pop DE
  pop BC

  push BC
  push DE
  ld B, D
  ld HL, frame_q3
  call Print_Udgs_Character
  pop DE
  pop BC

  push BC
  push DE
  ld B, D
  ld C, E
  ld HL, frame_q4
  call Print_Udgs_Character
  pop DE
  pop BC

  push BC
  push DE
  inc C
  ld  D, B  ; lower right row
  dec E
  ld HL, frame_up
  call Print_Udgs_Tile
  pop DE
  pop BC

  push BC
  push DE
  ld  B, D
  inc C
  dec E
  ld HL, frame_down
  call Print_Udgs_Tile
  pop DE
  pop BC

  push BC
  push DE
  inc B
  dec D
  ld  E, C
  ld HL, frame_left
  call Print_Udgs_Tile
  pop DE
  pop BC

  push BC
  push DE
  inc B
  ld  C, E
  dec D
  ld HL, frame_right
  call Print_Udgs_Tile
  pop DE
  pop BC

  ret

