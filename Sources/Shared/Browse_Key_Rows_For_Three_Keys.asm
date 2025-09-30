;===============================================================================
; Browse_Key_Rows_For_Three_Keys
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
; - record pressed_key_rows (defined here) holds the number of pressed keys
;   and their unique codes
;-------------------------------------------------------------------------------
Browse_Key_Rows_For_Three_Keys:

  ;-------------------------------------------------------------
  ;
  ; Set the HL to point to the beginning of array all_key_ports
  ;
  ;-------------------------------------------------------------
  ld HL, all_key_ports

  ;----------------------------------------------
  ;
  ; Set the HL' to point to the list of pressed
  ; keys and initialize the key counters to zero
  ;
  ; Here:
  ; HL -> pressed_keys_record
  ; HL + 1 ; first pressed key
  ; HL + 2 ; second pressed key
  ; HL + 3 ; third pressed key
  ;
  ;----------------------------------------------
  exx
  ld HL, pressed_keys_record
  ld BC,   0  ; reset the local key counter (just in this sub)
  ld (HL), 0  ; reset the global key counter (in RAM)
  exx

  ;------------------------------
  ;
  ; There are eight rows of keys
  ;
  ;------------------------------
  ld D, 0  ; there are eight rows of keys

.browse_key_rows:

    ;------------------------------------------------------------------
    ; Keyboard row; load the port number into BC indirectly through HL
    ;------------------------------------------------------------------
    ld C, (HL) : inc HL ; low byte into C
    ld B, (HL) : inc HL ; high byte into B

    ;------------------------------------------------
    ; Read key states (1 = not pressed, 0 = pressed)
    ;------------------------------------------------
.go_for_key_0  ; this is just for kicks, never really called
    in A, (C) : and  %00011111  ; only bits 0..4 matter
    bit 0, A : ld E, 0 : jr z, .a_key_pressed

.go_for_key_1
    in A, (C) : and  %00011111  ; only bits 0..4 matter
    bit 1, A : ld E, 1 : jr z, .a_key_pressed

.go_for_key_2
    in A, (C) : and  %00011111  ; only bits 0..4 matter
    bit 2, A : ld E, 2 : jr z, .a_key_pressed

.go_for_key_3
    in A, (C) : and  %00011111  ; only bits 0..4 matter
    bit 3, A : ld E, 3 : jr z, .a_key_pressed

.go_for_key_4
    in A, (C) : and  %00011111  ; only bits 0..4 matter
    bit 4, A : ld E, 4 : jr z, .a_key_pressed

    ;------------------------------------------------------------------
    ; If no key in this row is pressed, skip the section which follows
    ;------------------------------------------------------------------
    jr .no_key_pressed

.a_key_pressed
    ;----------------------------------------
    ; Form the unique key code here from the
    ; values in D (key row) and E (key bit)
    ;----------------------------------------
    ld A, E   ; A now holds a value from 0 to 4 (%000 to %100)
    add A, A  ; it is faster than sla A
    add A, A
    add A, A  ; if E was %100, A would now be %100000 (32)
    or D      ; if D was %111, A would now be %100111 (39)

    ;----------------------------------------
    ; Increase the pressed key count and
    ; unique key codes in pressed_key_record
    ;----------------------------------------
    exx
    inc (HL)    ; increase the pressed key count
    inc C       ; the same thing (note that pressed_key_record is aligned to 8)
    add HL, BC  ; B is zero, C in the range 1 to 3
    ld (HL), A  ; store the pressed key unique code into the record
    xor A       ; set flags to zero
    sbc HL, BC  ; let it point again to the beginning of the record

    ;------------------------------------------------------
    ; Check if you just pressed (and stored) the third key
    ;------------------------------------------------------
    ld A, C  ; place the value of C (still C') into A
    exx
    cp 3     ; did you already press and store three keys?
    ret z    ; yes, you pressed three keys, get out of here

    ;--------------------------------------------------------------
    ; If here, you didn't scan three keys yet, go for the next bit
    ;--------------------------------------------------------------
    ld A, E
    cp 0 : jr z, .go_for_key_1
    cp 1 : jr z, .go_for_key_2
    cp 2 : jr z, .go_for_key_3
    cp 3 : jr z, .go_for_key_4

.no_key_pressed
    ;------------------------------------------------
    ; Go up to D is 8, until all ports are exhausted
    ;------------------------------------------------
    inc D
    ld A, D
    cp 8

  jr nz, .browse_key_rows        ; go for the next key row

  ret

;-----------------------------------------------
; List of unique key codes for the pressed keys
;-----------------------------------------------
  align 8
pressed_keys_record:
;       number of pressed keys,  list of unique key codes for three keys
  defb  0,                       0,  0,  0
