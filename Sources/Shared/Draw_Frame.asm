Draw_Frame:

  ;----------------------
  ;
  ; Draw the frame first
  ;
  ;----------------------

  ;---------------------------------------------------------
  ; If it is from the Memory_Browser, take only one version
  ; (This is done to save memory)
  ;---------------------------------------------------------
  ifdef __MEMORY_BROWSER_MAIN__
  ld IX, frame_version_2
  endif

  ifndef __MEMORY_BROWSER_MAIN__

  ; Is it version 1?
  cp 1
  jr nz, .not_version_1     ; version is not set to 1
    ld IX, frame_version_1
    jr .selected_version
.not_version_1

  ; Is it version 2?
  cp 2
  jr nz, .not_version_2     ; version is not set to 2
    ld IX, frame_version_2
    jr .selected_version
.not_version_2

.selected_version
  endif

  ;--------------------------
  ; Create upper left corner
  ;--------------------------
  push BC
  push DE
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Character
  pop DE
  pop BC

  ;---------------------------
  ; Create upper right corner
  ;---------------------------
  push BC
  push DE
  ld A, C : add E : dec A : ld C, A  ; adjust column (C)
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Character
  pop DE
  pop BC

  ;--------------------------
  ; Create lower left corner
  ;--------------------------
  push BC
  push DE
  ld A, B : add D : dec A : ld B, A  ; adjust row (B)
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
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
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
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
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
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
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
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
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
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
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Tile
  pop DE
  pop BC

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Udgs/Print_Tile.asm"

;-------------------------
; Graphics for the frames
;-------------------------

  ifndef __MEMORY_BROWSER_MAIN__
frame_version_1:
  defw frame_v1_q1
  defw frame_v1_q2
  defw frame_v1_q3
  defw frame_v1_q4
  defw frame_v1_up
  defw frame_v1_down
  defw frame_v1_left
  defw frame_v1_right

frame_v1_q1:     defb $FF, $80, $BF, $BF, $B0, $B7, $B7, $B7
frame_v1_q2:     defb $FF, $01, $FD, $FD, $0D, $ED, $ED, $ED
frame_v1_q3:     defb $B7, $B7, $B7, $B0, $BF, $BF, $80, $FF
frame_v1_q4:     defb $ED, $ED, $ED, $0D, $FD, $FD, $01, $FF
frame_v1_up:     defb $FF, $00, $FF, $FF, $00, $FF, $FF, $FF
frame_v1_down:   defb $FF, $FF, $FF, $00, $FF, $FF, $00, $FF
frame_v1_left:   defb $B7, $B7, $B7, $B7, $B7, $B7, $B7, $B7
frame_v1_right:  defb $ED, $ED, $ED, $ED, $ED, $ED, $ED, $ED
  endif

frame_version_2:
  defw frame_v2_q1
  defw frame_v2_q2
  defw frame_v2_q3
  defw frame_v2_q4
  defw frame_v2_up
  defw frame_v2_down
  defw frame_v2_left
  defw frame_v2_right

frame_v2_q1:     defb $00, $00, $00, $00, $0F, $08, $0B, $0A ;
frame_v2_q2:     defb $00, $00, $00, $00, $F0, $10, $D0, $50 ;
frame_v2_q3:     defb $0A, $0B, $08, $0F, $00, $00, $00, $00 ;
frame_v2_q4:     defb $50, $D0, $10, $F0, $00, $00, $00, $00 ;
frame_v2_down:   defb $00, $FF, $00, $FF, $00, $00, $00, $00 ;
frame_v2_left:   defb $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A ;
frame_v2_right:  defb $50, $50, $50, $50, $50, $50, $50, $50 ;
frame_v2_up:     defb $00, $00, $00, $00, $FF, $00, $FF, $00 ;

