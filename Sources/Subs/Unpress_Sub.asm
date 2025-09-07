;===============================================================================
; Unpress_Sub
;-------------------------------------------------------------------------------
; Purpose:
; - Waits until all keys are unpressed
;
; Parameters (passed via memory locations)
; - all_key_ports
;-------------------------------------------------------------------------------
Unpress_Sub:

  ;-------------------------------------------------------------
  ; Set the HL to point to the beginning of array all_key_ports
  ;-------------------------------------------------------------
  ld HL, all_key_ports

  ;------------------------------
  ; There are eight rows of keys
  ;------------------------------
  ld D, 8              ; there are eight rows of keys

Unpress_Browse_Key_Rows:

  ; Load the port number into BC indirectly through HL
  ld C, (HL)  ; low byte into C
  inc HL
  ld B, (HL)  ; high byte into B
  inc HL
  in A, (C)           ; read key states (1 = not pressed, 0 = pressed)
  and  %00011111      ; mask out upper three bits, keep lower five
  cp   %00011111      ; compare with all ones in lower five bits
  jr nz, Unpress_Sub  ; if not all are 1, go back an read the keyboar again

  dec D

  jr nz, Unpress_Browse_Key_Rows

  ret
