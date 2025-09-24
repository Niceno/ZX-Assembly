;===============================================================================
; Print_Hex_Byte
;-------------------------------------------------------------------------------
; Parameters:
; - A: byte to print as two hexadecimal digits (from $00 to $FF)
;
; Clobbers:
; - nothing  REALLY?
;
; Calls:
; - Print_Narrow_Hex_Digit
; - Merge_Narrow_Hex_Digit
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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Print_Narrow_Hex_Digit.asm"
  include "Shared/Merge_Narrow_Hex_Digit.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;----------------------------
; Hex numbers in narrow form
;----------------------------
hex_0_low:  defb $00, $02, $05, $05, $05, $05, $02, $00 ;
hex_1_low:  defb $00, $02, $06, $02, $02, $02, $07, $00 ;
hex_2_low:  defb $00, $06, $01, $01, $02, $04, $07, $00 ;
hex_3_low:  defb $00, $06, $01, $02, $01, $01, $06, $00 ;
hex_4_low:  defb $00, $01, $03, $05, $07, $01, $01, $00 ;
hex_5_low:  defb $00, $07, $04, $06, $01, $01, $06, $00 ;
hex_6_low:  defb $00, $03, $04, $06, $05, $05, $02, $00 ;
hex_7_low:  defb $00, $07, $01, $01, $02, $02, $02, $00 ;
hex_8_low:  defb $00, $02, $05, $02, $05, $05, $02, $00 ;
hex_9_low:  defb $00, $02, $05, $05, $03, $01, $06, $00 ;
hex_a_low:  defb $00, $02, $05, $05, $07, $05, $05, $00 ;
hex_b_low:  defb $00, $06, $05, $06, $05, $05, $06, $00 ;
hex_c_low:  defb $00, $03, $04, $04, $04, $04, $03, $00 ;
hex_d_low:  defb $00, $06, $05, $05, $05, $05, $06, $00 ;
hex_e_low:  defb $00, $07, $04, $06, $04, $04, $07, $00 ;
hex_f_low:  defb $00, $07, $04, $06, $04, $04, $04, $00 ;
hex_0_high: defb $00, $20, $50, $50, $50, $50, $20, $00 ;
hex_1_high: defb $00, $20, $60, $20, $20, $20, $70, $00 ;
hex_2_high: defb $00, $60, $10, $10, $20, $40, $70, $00 ;
hex_3_high: defb $00, $60, $10, $20, $10, $10, $60, $00 ;
hex_4_high: defb $00, $10, $30, $50, $70, $10, $10, $00 ;
hex_5_high: defb $00, $70, $40, $60, $10, $10, $60, $00 ;
hex_6_high: defb $00, $30, $40, $60, $50, $50, $20, $00 ;
hex_7_high: defb $00, $70, $10, $10, $20, $20, $20, $00 ;
hex_8_high: defb $00, $20, $50, $20, $50, $50, $20, $00 ;
hex_9_high: defb $00, $20, $50, $50, $30, $10, $60, $00 ;
hex_a_high: defb $00, $20, $50, $50, $70, $50, $50, $00 ;
hex_b_high: defb $00, $60, $50, $60, $50, $50, $60, $00 ;
hex_c_high: defb $00, $30, $40, $40, $40, $40, $30, $00 ;
hex_d_high: defb $00, $60, $50, $50, $50, $50, $60, $00 ;
hex_e_high: defb $00, $70, $40, $60, $40, $40, $70, $00 ;
hex_f_high: defb $00, $70, $40, $60, $40, $40, $40, $00 ;

