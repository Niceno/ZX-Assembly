;===============================================================================
; Print_16_Bit_Number
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a 16 bit number, right-aligned
;
; Parameters:
; - HL: operand, the number we want to turn to ASCII
; - BC: row and column
;-------------------------------------------------------------------------------
Print_16_Bit_Number:

  push BC  ; preserve row and column

  ld IX, four_place_values

  ;-------------------------------------------------------------
  ; Browse through "place values", from 10000, 1000, 100 and 10
  ; substract them from the 16 bit number, to find out how many
  ; of each of decimal digits you have
  ;-------------------------------------------------------------
  ld B, 4  ; place values (10000, 1000, 100, 10)

.loop_place_values:

    ld D, (IX+1)  ; load DE pair with
    ld E, (IX+0)  ; place values

.loop_this_decimal_place:

      ; Check if we can subtract DE from HL *without* actually doing it yet.
      ; We need to see if HL >= DE.  We can use a 16-bit compare by doing a
      ; dummy subtraction that doesn't change HL.
      push HL         ; save HL (our 16-bit number)
      or A            ; clear the carry flag =--> IMPORTANT
      sbc HL, DE      ; this does HL = HL - DE, setting the flags.
      pop HL          ; immediately restore HL. We only care about the flags!

      ; Jump if HL < DE (Carry is SET)
      jr c, .done_this_decimal_place

      ; If we get here, HL >= DE, so we can safely subtract and count
      or A            ; clear the carry flag =--> IMPORTANT
      sbc HL, DE      ; now we *actually* subtract DE from HL.
      ld A, (IX+8)    ; fetch the value for current decimal place ...
      inc A           ; ... increase it in the accumulator ... 
      ld (IX+8), A    ; ... and copy back to memory

    ; Continue subtracting at this decimal place
    jr .loop_this_decimal_place

.done_this_decimal_place:

    ; Move to the next place value
    inc IX
    inc IX

  djnz .loop_place_values

  ; Handle the final digit (place value 1)
  ld A, L  ; what remaind from HL
  ld (IX+8), A

  ld DE, number_16_ascii  ; point to the string again

  ;-------------------------------------------------------
  ; With all place values calculate, form an ASCII string
  ;-------------------------------------------------------
  ld IX, four_place_values
  ld B, 5  ; five digits

.fill_ascii_loop:

    ld A, (IX+8)   ; this is where extracted digits start
    add A, CHAR_0  ; turn them into ASCII
    ld (DE), A     ; fill the target memory place
    ld A, 0        ; reset the used extracted digit ...
    ld (IX+8), A   ; ... using the A register
    inc IX
    inc IX
    inc DE

  djnz .fill_ascii_loop

  ;-----------------------
  ; Remove leading zeroes
  ;-----------------------

  ; Revert DE back to the beginning of the target memory place
  ld B, 5
.go_back:
    dec DE
  djnz .go_back

  ; Remove leading zeroes
  ld B, 4  ; check only four leading digits
.loop_leading_zeroes:
    ld A, (DE)
    cp CHAR_0
    jr nz, .removed_leading_zeroes
    ld A, CHAR_SPACE
    ld (DE), A
    inc DE
  djnz .loop_leading_zeroes

.removed_leading_zeroes:

  pop BC                    ; row and column
  ld HL, number_16_ascii
  call Print_String

  ret

; Place values followed by some extra places to store decimal digits
; Storage for decimal digits is not quite compact which is a consequence
; of the fact I couldn't use IY as the second pointer.  Anyway, to make
; it sound better, we could say that digits are stored as 16-bit numbers
four_place_values:
  defw 10000, 1000, 100, 10     ; four_place_values
  defb 0,0, 0,0, 0,0, 0,0, 0,0  ; storage for decimal digits

number_16_ascii:  ; leave space for five digits, plus a trailing zero
  defb "00000", 0

