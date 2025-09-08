;===============================================================================
; Print_Udgs_Character_Box_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a box filled up with single UDGs character
;
; Parameters (passed via registers)
; - HL: address of the UDG character to be printed
; - BC: text box row and column
; - DE: text box length and height
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Print_Udgs_Character_Box_Sub:

  ;--------------------------
  ; Outer loop; through rows
  ;--------------------------
  ld A, D
.loop_outer

    push AF  ; save the outer counter
    push BC  ; save the initial column (you also save the row along the way)

    ;--------------------------
    ; Inner loop; through rows
    ;--------------------------
    ld A, E
    push DE  ; save length and height

.loop_inner:
      push AF

      push BC
      push HL
      call Print_Udgs_Character_Sub  ; this clobbers B
      pop HL
      pop BC

      inc C  ; move to the next column

      pop AF
      dec A
    jr nz, .loop_inner

    pop DE  ; restore length (D) and height (E)

    pop BC  ; restore the row (B) and the column (C), ...
            ; ... C will be set to original value ...
    inc B   ; ... but you will increase B to the next row

    pop AF  ; restore the outer counter
    dec A

  jr nz, .loop_outer

  ret

