;===============================================================================
; Compare_Registers:
;-------------------------------------------------------------------------------
; Parameters:
; - HL: address of the first memory address
; - DE: address of the second memory address
;
; Changes:
; - AF: results in increased A and (possibly) clobbered F
;
; Note:
; - This is a "local function", called only from Print_Registers,
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Compare_Registers:

  push AF  ; beginning of the sub, store the A which holds the color
  push BC

  ;---------------------------------------------------------
  ; In case this is a second call, do the actual comparison
  ;---------------------------------------------------------
  ld A, (call_count)
  cp 2
  jr z, .this_is_the_second_call

  pop BC
  pop AF

  ret

.this_is_the_second_call:

  push AF  ; push AF for comparison

  ; Compare all bytes (why only two?)
  ld A, (DE)
  cp (HL)
  jr nz, .add_flashing
  inc HL
  inc DE
  ld A, (DE)
  cp (HL)
  jr nz, .add_flashing

  pop AF  ; comparison done, restore AF

  pop BC
  pop AF  ; restore AF from the beginning of this sub, the one with color

  ret

.add_flashing:

  pop AF  ; comparison done, restore AF

  pop BC
  pop AF  ; restore AF from the beginning of this sub, the one with color

  add FLASH

  ret

