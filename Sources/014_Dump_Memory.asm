  include "Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;-----------------------------------------------
; Memory address at which the program will load
;-----------------------------------------------
  org MEM_PROGRAM_START

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   MAIN SUBROUTINE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ; Imagine this is the desired memory address you want to print from
  ld HL, $0000

.browse_some_more
  push HL       ; save it for the later, when the keys are pressed

  ;---------------------------------------------------------------
  ; Oh well, this is the central thing here, dump those 128 bytes
  ;---------------------------------------------------------------
  call Dump_Memory

  ;-----------------
  ; Press Q to quit
  ;-----------------
  ld HL, text_press_q_to_quit
  ld B, 23 : ld C, 0
  call Print_String

  ld HL, text_4_and_9
  ld B, 22 : ld C, 0
  call Print_String

  ld HL, text_5_and_8
  ld B, 21 : ld C, 0
  call Print_String

  ld HL, text_6_and_7
  ld B, 20 : ld C, 0
  call Print_String

  ;-----------------------
  ; Loop for reading keys
  ;-----------------------
.wait_for_keys

    call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed

    cp KEY_0                  ; is the key "0" pressed?  Set z if so
    jr z, .done_browsing      ; quit if it is so, quit if "0" was pressed

    cp KEY_4
    jr z, .wanna_go_book_down

    cp KEY_5
    jr z, .wanna_go_page_down

    cp KEY_6
    jr z, .wanna_go_line_down

    cp KEY_7
    jr z, .wanna_go_line_up

    cp KEY_8
    jr z, .wanna_go_page_up

    cp KEY_9
    jr z, .wanna_go_book_up

    jr .wait_for_keys

  ;-----------------------------------------
  ; Book down is like increasing 1024 bytes
  ;-----------------------------------------
.wanna_go_book_down
  pop HL
  ld  DE, $0400
  add HL, DE
  jr .browse_some_more

  ;----------------------------------------
  ; Page down is like increasing 128 bytes
  ;----------------------------------------
.wanna_go_page_down
  pop HL
  ld  DE, $0080
  add HL, DE
  jr .browse_some_more

  ;--------------------------------------
  ; Line down is like increasing 8 bytes
  ;--------------------------------------
.wanna_go_line_down
  pop HL
  ld  DE, $0008
  add HL, DE
  jr .browse_some_more

  ;------------------------------------
  ; Line up is like decreasing 8 bytes
  ;------------------------------------
.wanna_go_line_up
  pop HL
  ld  DE, $0008
  sub HL, DE
  jr .browse_some_more

  ;--------------------------------------
  ; Page up is like decreasing 128 bytes
  ;--------------------------------------
.wanna_go_page_up
  pop HL
  ld  DE, $0080
  sub HL, DE
  jr .browse_some_more

  ;---------------------------------------
  ; Book up is like decreasing 1024 bytes
  ;---------------------------------------
.wanna_go_book_up
  pop HL
  ld  DE, $4000
  sub HL, DE
  jr .browse_some_more

  ;----------------------------------
  ; You get here when "0" is pressed
  ;----------------------------------
.done_browsing:
  pop HL

  ei

  ret

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
  ld B, 1 : ld C, 1  ; print it at 1, 1

  ld A, 16  ; outer loop counter
.vertical_loop
    push AF
    push BC  ; store row and column

    ;--------------------------------------
    ;
    ; Print the memory address range first
    ;
    ;--------------------------------------

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
    inc C
    push BC
    push HL
    call Print_Hex_Byte
    pop HL
    pop BC

    ;---------------------------------------
    ; Print the second address in the range
    ;---------------------------------------
    push HL

    ; Increase HL by 7
    ld DE, $0007
    add HL, DE
    inc C
    inc C

    ; Print hight byte first
    ld A, H
    push BC
    push HL
    call Print_Hex_Byte
    pop HL
    pop BC

    ; Print low byte second
    ld A, L
    inc C
    push BC
    push HL
    call Print_Hex_Byte
    pop HL
    pop BC

    pop HL

    ;--------------------------------------------
    ;
    ; Print what is stored in this address range
    ;
    ;--------------------------------------------
    ld A, 8
.horizontal_loop
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
    jr nz, .horizontal_loop

    pop BC
    pop AF

    inc B
    dec A
  jr nz, .vertical_loop

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Udgs/Print_Character.asm"
  include "Subs/Udgs/Merge_Character.asm"
  include "Subs/Browse_Key_Rows.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_String.asm"

;===============================================================================
; Print_Hex_Byte
;-------------------------------------------------------------------------------
; Parameters:
; - A: byte to print as two hexadecimal digits (from $00 to $FF)
; - E: holds the horizontal offset to print the byte
;
; Clobbers:
; - nothing  REALLY?
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

;===============================================================================
; Print_Narrow_Hex_Digit
;-------------------------------------------------------------------------------
; Purpose:
; - Prints a "low" (right aligned) or a "high" (left aligned) digit as a
;   hexadecial number (from 0 to F)
;
; Parameters:
; - A:  digit (0-15) to print as hexadecimal
; - HL: beginning of the memory where characters are defined
;
; Clobbers:
; - nothing
;
; Note:
; - This is a "local function", called only from Print_Hex_Byte
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Print_Narrow_Hex_Digit:

  push HL
  push DE
  push BC
  push AF

  ; A is now the digit, multiply it with eight so that it becomes memory offset
  add A, A
  add A, A
  add A, A

  ; Calculate address of the string (string_0 to string_F)
  ld D, 0
  ld E, A                ; DE = digit value (0-15)
  add HL, DE             ; now point to the right character in the table

  ; Print the string
  call Print_Udgs_Character

  pop AF
  pop BC
  pop DE
  pop HL

  ret

;===============================================================================
; Merge_Narrow_Hex_Digit
;-------------------------------------------------------------------------------
; Purpose:
; - Merges a "low" (right aligned) or a "high" (left aligned) digit as a
;   hexadecial number (from 0 to F)
;
; Parameters:
; - A:  digit (0-15) to print as hexadecimal
; - HL: beginning of the memory where characters are defined
;
; Clobbers:
; - nothing
;
; Note:
; - This is a "local function", called only from Print_Hex_Byte
;   that's why it is not in a separate file
;-------------------------------------------------------------------------------
Merge_Narrow_Hex_Digit:

  push HL
  push DE
  push BC
  push AF

  ; A is now the digit, multiply it with eight so that it becomes memory offset
  add A, A
  add A, A
  add A, A

  ; Calculate address of the string (string_0 to string_F)
  ld D, 0
  ld E, A                ; DE = digit value (0-15)
  add HL, DE             ; now point to the right character in the table

  ; Print the string
  call Merge_Udgs_Character

  pop AF
  pop BC
  pop DE
  pop HL

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

text_6_and_7        :  defb "[6]/[7]:a line (   8 B) down/up", 0
text_5_and_8        :  defb "[5]/[8]:a page ( 128 B) down/up", 0
text_4_and_9        :  defb "[4]/[9]:a book (1024 B) down/up", 0
text_press_q_to_quit:  defb "[0]    :quit", 0

; Hex numbers
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

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
; (Without label "Main", you could have written: SAVESNA "bojan.sna", $8000)
;-------------------------------------------------------------------------------
  savesna "bojan_014.sna", Main
  savebin "bojan_014.bin", Main, $ - Main

