;===============================================================================
; Viewport_Scroll_Attributes_Up
;-------------------------------------------------------------------------------
; Purpose:
; - Scrolls the attributes inside the viewport up
;
; Parameters:
; - viewport_attribute_addresses
;
; Clobbers:
; - AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
Viewport_Scroll_Attributes_Up

  ;-------------------------------------------------------------------------
  ; Fetch the number of columns from viewport_*_metadata and store it in
  ; the BC pair.  (BC pair is convenient because used in ldir command below
  ;-------------------------------------------------------------------------
  ld IX, viewport_attribute_metadata

  ld C, (IX+2)  ; let the pair BC hold the number of bytes to transfer
  ld B, 0       ; high byte is zero

  ;--------------------------------------------
  ; Use A as the loop counter through the rows
  ;--------------------------------------------
  ld A, (IX+0)  ; number of rows inside the viewport
  dec A         ; copy one less than the dimension

  ;-----------------------------
  ; Main loop for pixel copying
  ;-----------------------------
  ld IX, viewport_attribute_addresses  ; let IX point to attribute addresses
.loop_rows
    ld E, (IX+0)  ; first row (target) goes into DE
    ld D, (IX+1)
    ld L, (IX+2)  ; second row (source) goes into HL
    ld H, (IX+3)

    ; Perform the copy
    push BC       ; store the number of columns
    ldir          ; copy BC bytes from (HL) to (DE)
    pop BC        ; restore the number of columns

    inc IX
    inc IX
    dec A
  jr nz, .loop_rows

  ret
