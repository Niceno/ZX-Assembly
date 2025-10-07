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

  ;------------------------------
  ; Select the type of the frame
  ;- - - - - - - - - - - - - - -
  ; Be mindfull that each frame
  ; definition is 80 bytes long
  ;------------------------------

  ; In general case
  ifndef __MEMORY_BROWSER_MAIN__
    ld IX, frame_definitions - 80
    ld A, H
    exx
    ld BC, 80
.loop_to_point_to_the_right_frame
      add IX, BC
      dec A
    jr nz, .loop_to_point_to_the_right_frame
    exx

  ; For memory browser, use only one
  else
    ld IX, frame_definitions
  endif

  ;-----------------
  ;
  ; Color the frame
  ;
  ;-----------------

  ; Color it only if it is not the mempory browser
  ifndef __MEMORY_BROWSER_MAIN__

    ld A, L  ; Store the color of the frame in A

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

  endif

  ;----------------
  ;
  ; Draw the frame
  ;
  ;----------------

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
;   LOCAL DATA
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
frame_definitions:
  include "Shared/Frames/Version_01.inc"
  ifndef __MEMORY_BROWSER_MAIN__
    include "Shared/Frames/Version_02.inc"
    include "Shared/Frames/Version_03.inc"
    include "Shared/Frames/Version_04.inc"
  endif
