;===============================================================================
; Delay_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Creates a delay of roughly 0.02 s.
;
; Parameters (passed via memory locations):
; - none
;-------------------------------------------------------------------------------
Delay_Sub:
  ei         ; enable interrupts, otherwise it gets stuck
             ; Speccy creates ~ 50 interruts per second, or each 0.02 seconds
  ld B, 10   ; length of delay; translates to roughly 0.2 s

Delay_Loop:
  halt             ; wait for an interrupt
  djnz Delay_Loop  ; loop

  ret

