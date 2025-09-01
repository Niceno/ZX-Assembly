;===============================================================================
; Open_Upper_Screen_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Opens the output to the upper screen
;
; Parameters (passed via memory locations):
; - none
;-------------------------------------------------------------------------------
Open_Upper_Screen_Sub:

  ld A, 2             ; upper screen is 2
  call ROM_CHAN_OPEN  ; open channel

  ret
