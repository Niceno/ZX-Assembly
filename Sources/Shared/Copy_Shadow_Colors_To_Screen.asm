;===============================================================================
; Copy_Shadow_Colors_To_Screen
;-------------------------------------------------------------------------------
; Purpose:
; - Coppies attributes from the shadow memory to the screen
;
; Parameters:
; - none
;
; Clobbers:
; - BC, DE, HL
;-------------------------------------------------------------------------------
Copy_Shadow_Colors_To_Screen:

  ld HL, MEM_SHADOW_COLORS
  ld DE, MEM_SCREEN_COLORS
  ld BC, 768
  ldir

  ret

