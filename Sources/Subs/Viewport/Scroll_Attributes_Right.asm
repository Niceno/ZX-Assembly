;===============================================================================
; Viewport_Scroll_Attributes_Right
;-------------------------------------------------------------------------------
; Purpose:
; - Scrolls the attributes inside the viewport right
;
; Parameters:
; - viewport_attribute_addresses
;
; Clobbers:
; - AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
Viewport_Scroll_Attributes_Right

  ld IX, viewport_attribute_metadata

  ld C, (IX+2)  ; let the pair BC hold the number of bytes to transfer
  dec C         ; you will shift one column less
  ld B, 0       ; high byte is zero
  ; At this point, the BC pair holds number of columns (to be coppied)

  ; A will serve as the loop counter
  ld A, (IX+0)  ; number of rows inside the viewport

  ld IX, viewport_attribute_addresses
.loop_rows
    ld E, (IX+0)  ; first row (target) goes into DE
    ld D, (IX+1)
    ld L, (IX+0)  ; second row (source) goes into HL
    ld H, (IX+1)
    ex DE, HL     ; DE = DE + BC (via HL)
    add HL, BC
    ex DE, HL
    add HL, BC    ; HL = HL + BC
    dec HL

    ; Perform the copy
    push BC       ; store the number of columns
    lddr          ; copy BC bytes from (HL) to (DE)
    pop BC        ; restore the number of columns

    inc IX
    inc IX
    dec A
  jr nz, .loop_rows

  ret
