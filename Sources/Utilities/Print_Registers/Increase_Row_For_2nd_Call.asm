;===============================================================================
; Increase_Row_For_2nd_Call:
;-------------------------------------------------------------------------------
; Purpose:
; - Increases B by 10 for the 2nd call
;-------------------------------------------------------------------------------
Increase_Row_For_2nd_Call:

  push AF

  ld A, (call_count)
  cp 2
  jr z, .this_is_the_second_call

  pop AF

  ret

.this_is_the_second_call:
  ld A, B
  add A, 10
  ld B, A

  pop AF

  ret

