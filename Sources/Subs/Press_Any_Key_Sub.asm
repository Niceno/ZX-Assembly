;===============================================================================
; Press_Any_Key_Sub
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
Press_Any_Key_Sub:

Press_Any_Key_Loop:

  ;-------------------------------------------------------------
  ; Set the HL to point to the beginning of array all_key_ports
  ;-------------------------------------------------------------
  ld HL, all_key_ports

  ;------------------------------
  ; There are eight rows of keys
  ;------------------------------
  ld D, 8

Press_Any_Key_Browse_Key_Rows:

  ; Keyboard row; load the port number into BC indirectly through HL
  ld C, (HL)       ; low byte into C
  inc HL
  ld B, (HL)       ; high byte into B
  inc HL

  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A         ; bit 0
  jr z, Main_Pressed_Any_Key
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A         ; bit 1
  jr z, Main_Pressed_Any_Key
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A         ; bit 2
  jr z, Main_Pressed_Any_Key
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A         ; bit 3
  jr z, Main_Pressed_Any_Key
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A         ; bit 4
  jr z, Main_Pressed_Any_Key

  dec D  ; counter for rows of keys

  jr nz, Press_Any_Key_Browse_Key_Rows

  jr Press_Any_Key_Loop    ; if not pressed, repeat loop

Main_Pressed_Any_Key:

  ret

