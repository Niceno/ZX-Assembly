;===============================================================================
; Copy_Shadow_Pixels_To_Screen
;-------------------------------------------------------------------------------
Copy_Shadow_Pixels_To_Screen:

  ld HL, MEM_SHADOW_PIXELS
  ld DE, MEM_SCREEN_PIXELS
  ld BC, 6144
  ldir

  ret
