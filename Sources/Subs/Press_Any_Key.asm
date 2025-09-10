;===============================================================================
; Press_Any_Key
;-------------------------------------------------------------------------------
; Purpose:
; - Runs an infinite loop until any key is pressed
;
; Parameters:
; - none
;
; Clobbers:
; - AF, BC, DE, HL
;-------------------------------------------------------------------------------
Press_Any_Key:

;--------------------------------
;
; Infinite loop for reading keys
;
;--------------------------------
.outer_infinite_loop:

  ;-------------------------------------------------------------
  ; Set the HL to point to the beginning of array all_key_ports
  ;-------------------------------------------------------------
  ld HL, all_key_ports

    ;------------------------------
    ; There are eight rows of keys
    ;------------------------------
    ld D, 8

.browse_key_rows:

      ; Keyboard row; load the port number into BC indirectly through HL
      ld C, (HL)  ; low byte into C
      inc HL
      ld B, (HL)  ; high byte into B ("in A, (C)" needs both B and C set)
      inc HL

      in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
      bit 0, A         ; bit 0
      jr z, .any_key_pressed
      in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
      bit 1, A         ; bit 1
      jr z, .any_key_pressed
      in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
      bit 2, A         ; bit 2
      jr z, .any_key_pressed
      in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
      bit 3, A         ; bit 3
      jr z, .any_key_pressed
      in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
      bit 4, A         ; bit 4
      jr z, .any_key_pressed

      dec D  ; counter for rows of keys

    jr nz, .browse_key_rows

  jr .outer_infinite_loop    ; if not pressed, repeat loop

.any_key_pressed:

  ret

