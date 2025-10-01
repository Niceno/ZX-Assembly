;===============================================================================
; Delay
;-------------------------------------------------------------------------------
; Purpose:
; - Creates a delay for specified number of interrupts
;
; Parameters:
; - B: number of interrups for delay.  Each delay is 0.02 s.  So, five delays,
;      for example, would be 0.1 s; ten delays 0.2 s, and so forth.
;-------------------------------------------------------------------------------
Delay:

  ei  ; enable interrupts, otherwise it gets stuck

.loop:        ; loop over B (which is a parameter)
    halt      ; wait for an interrupt
  djnz .loop  ; loop

  ret

