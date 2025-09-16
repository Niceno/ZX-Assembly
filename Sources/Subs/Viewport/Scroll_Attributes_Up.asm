;===============================================================================
; Viewport_SCroll_Attributes_Up
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
Viewport_SCroll_Attributes_Up

  ld IX, viewport_attribute_metadata

  ld C, (IX+2)  ; let the pair BC hold the number of bytes to transfer
  ld B, 0       ; high byte is zero
  ; At this point, the BC pair holds number of columns (to be coppied)

  ; A will serve as the loop counter
  ld A, (IX+0)  ; number of rows inside the viewport
  dec A         ; copy one less than the dimension

  ld IX, viewport_attribute_addresses
.loop_rows
    push BC       ; store the number of columns
    ld E, (IX+0)  ; first row (target) goes into DE
    ld D, (IX+1)
    ld L, (IX+2)  ; second row (source) goes into HL
    ld H, (IX+3)
    ldir          ; copy BC bytes from (HL) to (DE)
    inc IX
    inc IX
    pop BC        ; restore the number of columns
    dec A
  jr nz, .loop_rows

  ret
