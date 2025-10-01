;===============================================================================
; Copy_Shadow_Pixels_To_Screen
;-------------------------------------------------------------------------------
; Purpose:
; - Coppies pixels from the shadow memory to the screen
;
; Parameters:
; - none
;
; Clobbers:
;-------------------------------------------------------------------------------
Copy_Shadow_Pixels_To_Screen:

  ld HL, MEM_SHADOW_PIXELS
  ld DE, MEM_SCREEN_PIXELS
  ld BC, 6144
  ldir

  ret

