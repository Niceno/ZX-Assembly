;===============================================================================
; Print_Hex_Byte
;-------------------------------------------------------------------------------
; Parameters:
; - A: byte to print as two hexadecimal digits (from $00 to $FF)
; - E: holds the horizontal offset to print the byte
;
; Clobbers:
; - nothing  REALLY?
;
; Note:
; - This is a "local function", called only from Print_Registers,
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Print_Hex_Byte:

  push AF
  push DE
  push HL
  push BC

  ;-------------------------
  ; Print high nibble first
  ;-------------------------
  push AF
  rra                       ; shift right 4 bits
  rra
  rra
  rra
  and $0F                   ; mask lower 4 bits
  ld HL, hex_0_high         ; point to the start of character table
  call Print_Narrow_Hex_Digit
  pop AF

  ;--------------------------
  ; Merge low nibble over it
  ;--------------------------
  push AF
  and $0F                   ; mask lower 4 bits
  ld HL, hex_0_low          ; point to the start of character table
  call Merge_Narrow_Hex_Digit
  pop AF

  pop BC
  pop HL
  pop DE
  pop AF

  ret

