;===============================================================================
; Viewport_Store_Data_For_Attributes
;-------------------------------------------------------------------------------
; Note:
; - This sub is called only once, when a viewport is created
;-------------------------------------------------------------------------------
Viewport_Store_Data_For_Attributes

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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
viewport_attribute_metadata:
  defw  $0000      ; + 0 number of rows
  defw  $0000      ; + 2 number of columns
  defb  ">>>>>>>>>>> VIEW"
  defb  "PORT >>>>>>>>>>>"
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
  defw  $0000      ; +46 24th row in the viewport
  defb  "<<<<<<<<<<< VIEW"
  defb  "PORT <<<<<<<<<<<"

