;===============================================================================
; Viewport_Scroll_Attributes_Right
;-------------------------------------------------------------------------------
; Purpose:
; - Scrolls the attributes inside the viewport right
;
; Parameters:
; - none, it uses global variables to know which portion of the screen to scroll
;
; Global variables used:
; - viewport_attribute_metadata
; - viewport_attribute_addresses
;
; Clobbers:
; - AF, BC, DE, HL, IX
;-------------------------------------------------------------------------------
Viewport_Scroll_Attributes_Right

  ;-------------------------------------------------------------------------
  ; Fetch the number of columns from viewport_*_metadata and store it in
  ; the BC pair.  (BC pair is convenient because used in ldir command below
  ;-------------------------------------------------------------------------
  ld IX, viewport_attribute_metadata

  ld C, (IX+1)  ; let the pair BC hold the number of bytes to transfer
  dec C         ; you will shift one column less
  ld B, 0       ; high byte is zero

  ;--------------------------------------------
  ; Use A as the loop counter through the rows
  ;--------------------------------------------
  ld A, (IX+0)  ; number of rows inside the viewport

  ;---------------------------------
  ; Main loop for attribute copying
  ;---------------------------------
  ld IX, viewport_attribute_addresses  ; let IX point to attribute addresses

.loop_rows
    ld E, (IX+0)  ; target address goes into DE
    ld D, (IX+1)
    ld L, (IX+0)  ; source address goes into HL
    ld H, (IX+1)
    ex DE, HL     ; DE = DE + BC (via HL)
    add HL, BC
    ex DE, HL
    add HL, BC    ; HL = HL + BC
    dec HL

    ; Perform the copy
    push BC  ; store the number of columns
    lddr     ; copy BC bytes from (HL) to (DE)
    pop BC   ; restore the number of columns

    inc IX
    inc IX
    dec A
  jr nz, .loop_rows

  ret
