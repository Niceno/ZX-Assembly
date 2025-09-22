;===============================================================================
; Dump_Memory
;-------------------------------------------------------------------------------
; Parameters:
; - BC: row and column, where the memory dump begins
; - HL: initial memory address
;-------------------------------------------------------------------------------
Dump_Memory:

  ;-----------------------------------------------------
  ;
  ; Set the row and column where you want this to begin
  ;
  ;-----------------------------------------------------
  ld B, 1 : ld C, 1  ; start printing it at 0, 0

  ld A, 16  ; outer loop counter
.vertical_loop
    push AF
    push BC  ; store row and column

    ;-------------------------------------------
    ;
    ; Color every other line in different color
    ;
    ;-------------------------------------------
    ld A, WHITE_PAPER + BLACK_INK

    bit 3, L  ; does it end with 8?
    jr nz, .number_ends_with_eight

    ld A, WHITE_PAPER + BLUE_INK

.number_ends_with_eight    
    ld E, 30

    push BC
    push HL
    call Color_Line
    pop HL
    pop BC

    ;--------------------------------------
    ;
    ; Print the memory address range first
    ;
    ;--------------------------------------

    ;-----------------------------
    ; Is it some special address?
    ;-----------------------------

    ld A, H : xor high MEM_FONT_START        : or L  ; @ MEM_FONT_START
    jr z, .hl_is_special                             ;   nope
    ld A, H : xor high MEM_SCREEN_PIXELS     : or L  ; @ MEM_SCREEN_PIXELS?
    jr z, .hl_is_special                             ;   nope
    ld A, H : xor high MEM_SCREEN_COLORS     : or L  ; @ MEM_SCREEN_COLORS?
    jr z, .hl_is_special                             ;   nope
    ld A, H : xor high MEM_PRINTER_BUFFER    : or L  ; @ MEM_PRINTER_BUFFER
    jr z, .hl_is_special                             ;   nope
    ld A, H : xor high MEM_SYSTEM_VARS       : or L  ; @ MEM_SYSTEM_VARS?
    jr z, .hl_is_special                             ;   nope
    ld A, H : xor high MEM_PROGRAM_START     : or L  ; @ MEM_PROGRAM_START
    jr z, .hl_is_special                             ;   nope
    ld A, H : xor high MEM_CUSTOM_FONT_START : or L  ; @ MEM_CUSTOM_FONT_START
    jr z, .hl_is_special                             ;   nope

    jr .hl_is_not_special

.hl_is_special
    ld A, RED_PAPER + WHITE_INK
    ld E, 2
    push BC
    push HL
    call Color_Line
    pop HL
    pop BC

.hl_is_not_special

    ;--------------------------------------
    ; Print the first address in the range
    ;--------------------------------------

    ; Print hight byte first
    ld A, H  ; A holds the high byte, that will be printed
    push BC
    push HL
    call Print_Hex_Byte
    pop HL
    pop BC

    ; Print low byte second
    ld A, L  ; A holds the low byte, that will be printed
    inc C    ; increase column
    push BC
    push HL
    call Print_Hex_Byte
    pop HL
    pop BC

    ;-------------------------------
    ;
    ; Plot graphical representation
    ;
    ;-------------------------------
    push BC
    push HL
    ld A, C : add 18 : ld C, A
    call Print_Udgs_Character
    pop HL
    pop BC

    ;-------------------------------------------------------------
    ;
    ; Print what is stored in this address range with hex numbers
    ;
    ;-------------------------------------------------------------
    push BC
    push HL

    ld A, 8
.horizontal_loop_hex
      push AF

      inc C : inc C  ; shift a little bit
      ld A, (HL)
      push BC
      push HL
      call Print_Hex_Byte
      pop HL
      pop BC
      inc HL

      pop AF
      dec A
    jr nz, .horizontal_loop_hex

    pop HL
    pop BC

    ;------------------------------------------------------------------
    ;
    ; Print what is stored in this address range with ASCII characters
    ;
    ;------------------------------------------------------------------
    ld A, C : add 20 : ld C, A
    ld A, 8
.horizontal_loop_ascii
      push AF

      ld A, (HL)

      cp CHAR_SPACE          ; lower bound
      jr c,  .not_printable  ; A < 32, not printable

      cp 143                 ; upper bound
      jr nc, .not_printable  ; A > 143, not printable

      ; If you are here, it is printable

      push BC
      push HL
      call Print_Character  ; BC are row/column, HL address of the character
      pop HL
      pop BC

      jr .done_with_this_memory_place

.not_printable

      push BC
      push HL
      ld HL, empty
      call Print_Udgs_Character
      pop HL
      pop BC

.done_with_this_memory_place

      inc C
      inc HL

      pop AF
      dec A
    jr nz, .horizontal_loop_ascii


    pop BC  ; row and column
    pop AF  ; counter

    inc B   ; increase row
    dec A   ; decrease counter
  jp nz, .vertical_loop

  ret

