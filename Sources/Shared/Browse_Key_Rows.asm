;===============================================================================
; Browse_Key_Rows
;-------------------------------------------------------------------------------
; Purpose:
; - Browse through all key rows (Speccy has eight of them), and checks if any
;   of the keys (denominated by bits in A after the "in" command) are pressed
;   and, if pressed, creates a unique key code.  It is pretty cool really.
;
; Global variables used:
; - all_key_ports global array
;
; Clobbers:
; - AF, BC, DE, HL
;
; Output:
; - A holds the key code
; - C holds one if a key was pressed, or zero if no key was pressed
;-------------------------------------------------------------------------------
Browse_Key_Rows:

  ;-------------------------------------------------------------
  ; Set the HL to point to the beginning of array all_key_ports
  ;-------------------------------------------------------------
  ld HL, all_key_ports

  ;------------------------------
  ; There are eight rows of keys
  ;------------------------------
  ld D, 0        ; there are eight rows of keys

.browse_key_rows:

    ; Keyboard row; load the port number into BC indirectly through HL
    ld C, (HL)  ; low byte into C
    inc HL
    ld B, (HL)  ; high byte into B
    inc HL

    ; Read key states (1 = not pressed, 0 = pressed)
    in A, (C)
    and  %00011111  ; only bits 0..4 matter
    bit 0, A : ld E, 0 : jp z, .a_key_pressed
    bit 1, A : ld E, 1 : jp z, .a_key_pressed
    bit 2, A : ld E, 2 : jp z, .a_key_pressed
    bit 3, A : ld E, 3 : jp z, .a_key_pressed
    bit 4, A : ld E, 4 : jp z, .a_key_pressed

    ; Jump the section for when a key is pressed
    jr .no_key_pressed

.a_key_pressed
    ; Form the unique key code here from the
    ; values in D (key row) and E (key bit)
    ld A, E  ; A now holds a value from 0 to 4 (%000 to %100)
    sla A
    sla A
    sla A    ; if E was %100, A would now be %100000 (32)
    or D     ; if D was %111, A would now be %100111 (39)
    ld C, 1  ; set the zeroth bit here (like the output flag)
    ret

.no_key_pressed
    ; Go up to D is 8, untill all ports are exhausted
    inc D
    ld A, D
    cp 8

  jr nz, .browse_key_rows        ; go for the next key row

  ld C, 0  ; set the zeroth bit here (like the output flag)

  ret
