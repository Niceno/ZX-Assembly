;===============================================================================
; Viewport_Scroll_Attributes_Down
;-------------------------------------------------------------------------------
; Purpose:
; - Scrolls the attributes inside the viewport down
;
; Parameters:
; - none, it uses global variables to know which portion of the screen to scroll
;
; Global variables used:
; - viewport_attribute_metadata
; - viewport_row_attribute_addresses_left_column
;
; Clobbers:
; - AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
Viewport_Scroll_Attributes_Down

  ;-------------------------------------------------------------------------
  ; Fetch the number of columns from viewport_*_metadata and store it in
  ; the BC pair.  (BC pair is convenient because used in ldir command below
  ;-------------------------------------------------------------------------
  ld IX, viewport_attribute_metadata

  ld C, (IX+1)  ; let BC hold the number of bytes to transfer
  ld B, 0       ; high byte is zero

  ;--------------------------------------------
  ; Use A as the loop counter through the rows
  ;--------------------------------------------
  ld A, (IX+0)  ; number of rows inside the viewport
  dec A         ; copy one less than the dimension

  ;---------------------------------
  ; Main loop for attribute copying
  ;---------------------------------

  ; This is to make IX point to last row in the attribute addresses
  ld E, (IX+2)
  ld D, (IX+3)
  push DE
  pop IX

.loop_rows_bottom_up
    ld E, (IX+0)  ; target address goes into DE
    ld D, (IX+1)
    ld L, (IX-2)  ; source address goes into HL
    ld H, (IX-1)

    ; Perform the copy
    push BC  ; store the number of columns
    ldir     ; copy BC bytes from (HL) to (DE)
    pop BC   ; restore the number of columns

    dec IX
    dec IX
    dec A
  jr nz, .loop_rows_bottom_up

  ret
