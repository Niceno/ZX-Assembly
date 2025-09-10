;===============================================================================
; Print_Udgs_Sprite_Box
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a box filled up with an array of UDGs character
;
; Parameters (passed via registers)
; - HL: address of the UDG character to be printed
; - BC: text box row and column
; - DE: text box length and height
;
; Clobbers:
; - AF, BC, DE, HL ... but should be double checked
;-------------------------------------------------------------------------------
Print_Udgs_Sprite_Box:

  ;--------------------------
  ; Outer loop; through rows
  ;--------------------------
  ld A, D
.outer_loop:

    push AF  ; save the outer counter
    push BC  ; save the initial column (you also save the row along the way)

    ;--------------------------
    ; Inner loop; through rows
    ;--------------------------
    ld A, E
    push DE  ; save length and height

.inner_loop:
      push AF

      push BC
      push HL
      call Print_Udgs_Character  ; this clobbers B
      pop HL
      pop BC

      inc C  ; move to the next column

      inc HL  ; move to the next character
      inc HL
      inc HL
      inc HL
      inc HL
      inc HL
      inc HL
      inc HL

      pop AF
      dec A
    jr nz, .inner_loop

    pop DE  ; restore length (D) and height (E)

    pop BC  ; restore the row (B) and the column (C), ...
            ; ... C will be set to original value ...
    inc B   ; ... but you will increase B to the next row

    pop AF  ; restore the outer counter
    dec A

  jr nz, .outer_loop

  ret

