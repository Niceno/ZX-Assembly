;===============================================================================
; Delay_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Creates a delay of roughly 0.02 s.
;
; Parameters:
; - B: number of interrups for delay.  Each delay is 0.02 s.  So, five delays,
;      for example, would be 0.1 s; ten delas 0.2 s, and so forth.
;-------------------------------------------------------------------------------
Delay_Sub:
  ei         ; enable interrupts, otherwise it gets stuck

Delay_Loop:
  halt             ; wait for an interrupt
  djnz Delay_Loop  ; loop

  ret

