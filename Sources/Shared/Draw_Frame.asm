;===============================================================================
; Draw_Frame
;-------------------------------------------------------------------------------
; Purpose:
; - Draws a frame specified with upper left row and column (BC), and height
;   and width in cells (DE).  Type of the frame is specified in H, and the
;   color of the frame in L.
;
; Clobbers:
; - AF, IX
;-------------------------------------------------------------------------------
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

  ;------------------------------
  ; Select the type of the frame
  ;------------------------------
  ld A, H

  ; Is it version 1?
  cp 1
  jr nz, .not_version_1
    ld IX, frame_version_1
    jr .selected_version
.not_version_1

  ; Is it version 2?
  cp 2
  jr nz, .not_version_2
    ld IX, frame_version_2
    jr .selected_version
.not_version_2

  ; Is it version 3?
  cp 3
  jr nz, .not_version_3
    ld IX, frame_version_3
    jr .selected_version
.not_version_3

  ; Is it version 4?
  cp 4
  jr nz, .not_version_4
    ld IX, frame_version_4
    jr .selected_version
.not_version_4

  ; Is it version 5?
  cp 5
  jr nz, .not_version_5
    ld IX, frame_version_5
    jr .selected_version
.not_version_5

.selected_version

  endif

  ;-----------------------------------
  ; Store the color of the frame in A
  ;-----------------------------------
  ld A, L

  push AF
  push BC
  push DE
  push HL
  call Color_Hor_Line
  pop HL
  pop DE
  pop BC
  pop AF

  push AF
  push BC
  push DE
  push HL
  ex AF, AF' : ld A, B : add D : dec A : ld B, A : ex AF, AF'
  call Color_Hor_Line
  pop HL
  pop DE
  pop BC
  pop AF

  push AF
  push BC
  push DE
  push HL
  inc B
  dec D : dec D
  call Color_Ver_Line
  pop HL
  pop DE
  pop BC
  pop AF

  push AF
  push BC
  push DE
  push HL
  inc B
  ex AF, AF' : ld A, C : add E : dec A : ld C, A : ex AF, AF'
  dec D : dec D
  call Color_Ver_Line
  pop HL
  pop DE
  pop BC
  pop AF


  ;--------------------------
  ; Create upper left corner
  ;--------------------------
  push AF
  push BC
  push DE
  push HL
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Character
  pop HL
  pop DE
  pop BC
  pop AF

  ;---------------------------
  ; Create upper right corner
  ;---------------------------
  push AF
  push BC
  push DE
  push HL
  ld A, C : add A, E : dec A : ld C, A  ; adjust column (C)
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Character
  pop HL
  pop DE
  pop BC
  pop AF

  ;--------------------------
  ; Create lower left corner
  ;--------------------------
  push AF
  push BC
  push DE
  push HL
  ld A, B : add A, D : dec A : ld B, A  ; adjust row (B)
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Character
  pop HL
  pop DE
  pop BC
  pop AF

  ;---------------------------
  ; Create lower right corner
  ;---------------------------
  push AF
  push BC
  push DE
  push HL
  ld A, C : add A, E : dec A : ld C, A  ; adjust column (C)
  ld A, B : add A, D : dec A : ld B, A  ; adjust row (B)
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Character
  pop HL
  pop DE
  pop BC
  pop AF

  ;----------
  ; Frame up
  ;----------
  push AF
  push BC
  push DE
  push HL
  inc C
  dec E            ; don't overwrite the corner piece
  dec E            ; don't overwrite the corner piece
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Line_Tile
  pop HL
  pop DE
  pop BC
  pop AF

  ;------------
  ; Frame down
  ;------------
  push AF
  push BC
  push DE
  push HL
  ld A, B : add A, D : dec A : ld B, A  ; adjust row (B)
  inc C
  dec E                                 ; don't overwrite the corner piece
  dec E                                 ; don't overwrite the corner piece
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Line_Tile
  pop HL
  pop DE
  pop BC
  pop AF

  ;------------
  ; Frame left
  ;------------
  push AF
  push BC
  push DE
  push HL
  inc B
  dec D              ; don't overwrite the corner piece
  dec D              ; don't overwrite the corner piece
  ld  E, 1           ; set number of columns to 1
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Tile
  pop HL
  pop DE
  pop BC
  pop AF

  ;-------------
  ; Frame right
  ;-------------
  push AF
  push BC
  push DE
  push HL
  inc B                                 ; don't overwrite the corner piece
  ld A, C : add A, E : dec A : ld C, A  ; adjust column (C)
  dec D                                 ; don't overwrite the corner piece
  dec D                                 ; don't overwrite the corner piece
  ld  E, 1                              ; set number of columns to 1
  ld L, (IX+0) : ld H, (IX+1) : inc IX : inc IX
  call Print_Udgs_Tile
  pop HL
  pop DE
  pop BC
  pop AF

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Udgs/Print_Tile.asm"
  include "Shared/Color_Hor_Line.asm"
  include "Shared/Color_Ver_Line.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;----------------------------
; Original register contents
;----------------------------
orig_b:  defb 0
orig_c:  defb 0
orig_d:  defb 0
orig_e:  defb 0

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

;-----------
; Version 3
;-----------
frame_version_3:
  defw frame_v3_q1
  defw frame_v3_q2
  defw frame_v3_q3
  defw frame_v3_q4
  defw frame_v3_up
  defw frame_v3_down
  defw frame_v3_left
  defw frame_v3_right

frame_v3_q1:     defb  %00111111
                 defb  %01000000
                 defb  %10100000
                 defb  %10010000
                 defb  %10001000
                 defb  %10000100
                 defb  %10000011
                 defb  %10000010

frame_v3_q2:     defb  %11111100
                 defb  %00000010
                 defb  %00000101
                 defb  %00001001
                 defb  %00010001
                 defb  %00100001
                 defb  %11000001
                 defb  %01000001

frame_v3_q3:     defb  %10000010
                 defb  %10000011
                 defb  %10000100
                 defb  %10001000
                 defb  %10010000
                 defb  %10100000
                 defb  %01000000
                 defb  %00111111

frame_v3_q4:     defb  %01000001
                 defb  %11000001
                 defb  %00100001
                 defb  %00010001
                 defb  %00001001
                 defb  %00000101
                 defb  %00000010
                 defb  %11111100

frame_v3_up:     defb  %11111111
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %11111111
                 defb  %00000000

frame_v3_down:   defb  %00000000
                 defb  %11111111
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %11111111

frame_v3_left:   defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010

frame_v3_right:  defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001

;-----------
; Version 4
;-----------
frame_version_4:
  defw frame_v4_q1
  defw frame_v4_q2
  defw frame_v4_q3
  defw frame_v4_q4
  defw frame_v4_up
  defw frame_v4_down
  defw frame_v4_left
  defw frame_v4_right

frame_v4_q1:     defb  %10000000
                 defb  %00000000
                 defb  %10000000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100010

frame_v4_q2:     defb  %00000000
                 defb  %00000001
                 defb  %00000010
                 defb  %00000101
                 defb  %00001010
                 defb  %00010101
                 defb  %00101010
                 defb  %01010101

frame_v4_q3:     defb  %10001000
                 defb  %00100011
                 defb  %10000110
                 defb  %00101011
                 defb  %10001110
                 defb  %00111011
                 defb  %01101110
                 defb  %10111011

frame_v4_q4:     defb  %10101010
                 defb  %10010101
                 defb  %11101010
                 defb  %10110101
                 defb  %11101010
                 defb  %10111001
                 defb  %11101110
                 defb  %10111011

frame_v4_up:     defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000

frame_v4_down:   defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011

frame_v4_left:   defb  %10001000
                 defb  %00100010
                 defb  %10001000
                 defb  %00100010
                 defb  %10001000
                 defb  %00100010
                 defb  %10001000
                 defb  %00100010

frame_v4_right:  defb  %10101010
                 defb  %01010101
                 defb  %10101010
                 defb  %01010101
                 defb  %10101010
                 defb  %01010101
                 defb  %10101010
                 defb  %01010101

;-----------
; Version 5
;-----------
frame_version_5:
  defw frame_v5_q1
  defw frame_v5_q2
  defw frame_v5_q3
  defw frame_v5_q4
  defw frame_v5_up
  defw frame_v5_down
  defw frame_v5_left
  defw frame_v5_right

frame_v5_q1:     defb  %10000000
                 defb  %00000000
                 defb  %10000000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000

frame_v5_q2:     defb  %00000000
                 defb  %00000001
                 defb  %00000010
                 defb  %00000101
                 defb  %00001010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101

frame_v5_q3:     defb  %10001000
                 defb  %00100000
                 defb  %10000110
                 defb  %00101011
                 defb  %10001110
                 defb  %00111011
                 defb  %01101110
                 defb  %10111011

frame_v5_q4:     defb  %00101010
                 defb  %00010101
                 defb  %11101010
                 defb  %10110101
                 defb  %11101010
                 defb  %10111001
                 defb  %11101110
                 defb  %10111011

frame_v5_up:     defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000

frame_v5_down:   defb  %00000000
                 defb  %00000000
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011

frame_v5_left:   defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000

frame_v5_right:  defb  %00101010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101


