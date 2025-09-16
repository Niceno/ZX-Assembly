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
  push BC
  push DE
  ld A, BLACK_INK + MAGENTA_PAPER  ; color not implemented yet
  dec B : dec C                    ; expand the frame to ...
  inc D : inc D : inc E : inc E    ; ... enclose the viewport
  call Draw_Frame
  pop DE
  pop BC

  ;------------------------------------
  ;
  ; Store viewport data for attributes
  ;
  ;------------------------------------

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

