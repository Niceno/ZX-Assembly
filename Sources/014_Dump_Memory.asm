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

  call Main_Menu

  ei

  ret

;===============================================================================
; Main_Menu
;-------------------------------------------------------------------------------
; Purpose:
; - draws “defined keys” page
; - waits for D or R
; - dispatches by calling another sub
; - returns to caller (Main)
;-------------------------------------------------------------------------------
Main_Menu:

  call Unpress  ; unpress first

  ld A, (MEM_STORE_SCREEN_COLOR)  ; set color into A
  call Clear_Screen               ; clear the screen

  ;----------------------------
  ;
  ; Loop to print defined keys
  ;
  ;----------------------------

  ld B, 0 : ld C, 0
  ld HL, text_currently_defined
  call Print_String
  ld C, 0

.loop_to_print_defined_keys

    ;----------------------
    ; First print the text
    ;----------------------
    push BC  ; save the counter

    ld L, C : ld H, 0    ; place C (count) in HL pair
    add  HL, HL          ; index * 2 (word table)
    ld   DE, text_current_address_table
    add  HL, DE          ; HL -> defw entry

    ld   E, (HL)  ; load string ptr
    inc  HL
    ld   D, (HL)
    ex   DE, HL   ; HL = prompt string

    ld   A, C          ; compute the row ...
    add  A, A          ; ... as twice the counter
    add  A, 2
    ld   B, A          ; set row
    ld   C, 1          ; set column
    call Print_String  ; prints zero-terminated string at HL

    pop BC

    ;--------------
    ; Then the key
    ;--------------
    push BC

    ld HL, currently_defined_keys
    ld D, 0 : ld E, C         ; place counter into DE
    add HL, DE                ; add it as an offset to HL

    ld D, 0 : ld A, (HL) : ld E, A  ; load DE with the unique key code

    ld IX, key_glyphs_address_table  ; add DE twice to IX ...
    add IX, DE                       ; ... making it an offset from ...
    add IX, DE                       ; ... key_glyphs_address_table
    ld L, (IX+0)                     ; finally load HL with the address ...
    ld H, (IX+1)                     ; ... pointed to by IX

    ld  A,  C
    add A,  A
    add A,  2                  ; row stride, increase rows by two
    ld  B,  A                  ; row
    ld  C, CURRENT_KEY_COLUMN  ; column
    call Print_Udgs_Character

    pop BC             ; retreive the counter ...
    inc C              ; ... increase it ...
    ld A, C            ; ... and via accumulator ...
    cp NUMBER_OF_UDKS  ; ... compare with NUMBER_OF_UDKS

  jr nz, .loop_to_print_defined_keys    ; loop until we've taken
                                        ; NUMBER_OF_UDKS presses

  ;--------------------------------------------------
  ;
  ; Press B to browse, D to define keys or Q to quit
  ;
  ;--------------------------------------------------
  ld HL, text_press_01 : ld B, 19 : ld C, 0 : call Print_String
  ld HL, text_press_02 : ld B, 21 : ld C, 0 : call Print_String
  ld HL, text_press_03 : ld B, 23 : ld C, 0 : call Print_String

.wait_for_keys_d_or_r

    call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed

    cp KEY_B                  ; is the key "B" pressed?  Set z if so
    call z, Browse_Memory

    cp KEY_D                  ; is the key "D" pressed?  Set z if so
    call z, Define_Keys

    cp KEY_Q                  ; is the key "Q" pressed?  Set z if so
    ret z

    jr .wait_for_keys_d_or_r

  ret  ; end of Main_Menu

;===============================================================================
; Define_Keys
;-------------------------------------------------------------------------------
; Purpose:
; - Shows prompts, records 5 keys
; - Returns to caller (menu)
;-------------------------------------------------------------------------------
Define_Keys:

  call Unpress  ; unpress first

  ld A, (MEM_STORE_SCREEN_COLOR)  ; set color into A
  call Clear_Screen               ; clear the screen

  ;---------------------
  ;
  ; Loop to define keys
  ;
  ;---------------------
  ld C, 0  ; counter for keys

.define_keys:

    ;------------------------
    ; Print a prompting text
    ;------------------------
    push BC  ; keep the counter safe

    ld L, C : ld H, 0    ; place C (count) in HL pair
    add  HL, HL          ; index * 2 (word table)
    ld   DE, text_current_address_table
    add  HL, DE          ; HL -> defw entry

    ld   E, (HL)  ; load string ptr
    inc  HL
    ld   D, (HL)
    ex   DE, HL   ; HL = prompt string

    ld   A, C          ; compute the row ...
    add  A, A          ; ... as twice the counter
    ld   B, A          ; set row
    ld   C, 1          ; set column
    call Print_String  ; prints zero-terminated string at HL

    pop  BC  ; restore the counter

    ;-----------------------------
    ; Browse through all key rows
    ;-----------------------------
    push BC               ; save the counter in C (through NUMBER_OF_UDKS keys)
    call Browse_Key_Rows  ; A = unique code, C bit0 = 1 if any key pressed
    bit  0, C             ; check C register's zeroth bit
    pop BC                ; retreive the counter in C

    jr z, .define_keys   ; no key pressed -> keep polling

    ;---------------------------------------------------
    ; A key was pressed - wait untill it gets unpressed
    ;---------------------------------------------------
    push AF       ; keep unique code in A safe
    push BC       ; save the counter in C
    call Unpress  ; wait until all keys released
    pop BC        ; restore the counter in C
    pop AF        ; restore the unique code in A

    ;---------------------------
    ; Process the key in A here
    ;---------------------------

    ; Store the defined key ... very important!!!
    ld HL, currently_defined_keys
    ld B, 0     ; with B set to zero, the pair BC will be the offset
    add HL, BC  ; add the offset to NUMBER_OF_UDKS defined keys
    ld (HL), A  ; store the key's unique code

    ; Print the key you just pressed ... quite handy
    ld IX, key_glyphs_address_table  ; point to all key glyphs table
    ld D, 0                          ; create offset from unique key code ...
    ld E, A                          ; ... (stored in A) in the the DE pair
    add IX, DE                       ; add the offset ...
    add IX, DE                       ; ... to IX pair
    ld L, (IX+0)                     ; finally load HL with the address ...
    ld H, (IX+1)                     ; ... pointed to by IX

    push BC                    ; save key counter (in C)
    ld   A, C                  ; compute the row ...
    add  A, A                  ; ... as twice the counter
    ld   B, A                  ; set row
    ld   C, 21                 ; set column
    call Print_Udgs_Character
    pop BC                     ; restore the counter

    ; Check if counter reached NUMBER_OF_UDKS
    inc C
    ld A, C
    cp NUMBER_OF_UDKS

  jp nz, .define_keys          ; loop until we've taken NUMBER_OF_UDKS presses

  call Main_Menu

  ret  ; end of Define_Keys

;===============================================================================
; Browse_Memory
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
Browse_Memory:

  ld A, (MEM_STORE_SCREEN_COLOR)  ; set color into A
  call Clear_Screen               ; clear the screen

  ; Imagine this is the desired memory address you want to print from
  ld HL, $0000  ; should be divisable by 8

.browse_some_more
  push HL       ; save it for the later, when the keys are pressed

  ;---------------------------------------------------------------
  ; Oh well, this is the central thing here, dump those 128 bytes
  ;---------------------------------------------------------------
  call Dump_Memory


  ;-----------------------
  ; Create a little delay
  ;-----------------------
  ld B, 5
  call Delay

  ;-----------------------
  ; Loop for reading keys
  ;-----------------------
.wait_for_keys

    call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed

    ld HL, key_to_quit : cp (HL)  ; is the key "0" pressed?  Set z if so
    jr z, .done_browsing          ; quit if it is so, quit if "0" was pressed

    ld HL, key_for_line_down : cp (HL)
    jr z, .wanna_go_line_down

    ld HL, key_for_page_down : cp (HL)
    jr z, .wanna_go_page_down

    ld HL, key_for_book_down : cp (HL)
    jr z, .wanna_go_book_down

    ld HL, key_for_line_up : cp (HL)
    jr z, .wanna_go_line_up

    ld HL, key_for_page_up : cp (HL)
    jr z, .wanna_go_page_up

    ld HL, key_for_book_up : cp (HL)
    jr z, .wanna_go_book_up

    jr .wait_for_keys

  ;-----------------------------------------
  ; Book down is like increasing 1024 bytes
  ;-----------------------------------------
.wanna_go_book_down
  pop HL
  ld  DE, $0400
  add HL, DE
  jp .browse_some_more

  ;----------------------------------------
  ; Page down is like increasing 128 bytes
  ;----------------------------------------
.wanna_go_page_down
  pop HL
  ld  DE, $0080
  add HL, DE
  jp .browse_some_more

  ;--------------------------------------
  ; Line down is like increasing 8 bytes
  ;--------------------------------------
.wanna_go_line_down
  pop HL
  ld  DE, $0008
  add HL, DE
  jp .browse_some_more

  ;------------------------------------
  ; Line up is like decreasing 8 bytes
  ;------------------------------------
.wanna_go_line_up
  pop HL
  ld  DE, $0008
  sub HL, DE
  jp .browse_some_more

  ;--------------------------------------
  ; Page up is like decreasing 128 bytes
  ;--------------------------------------
.wanna_go_page_up
  pop HL
  ld  DE, $0080
  sub HL, DE
  jp .browse_some_more

  ;---------------------------------------
  ; Book up is like decreasing 1024 bytes
  ;---------------------------------------
.wanna_go_book_up
  pop HL
  ld  DE, $4000
  sub HL, DE
  jp .browse_some_more

  ;----------------------------------
  ; You get here when "0" is pressed
  ;----------------------------------
.done_browsing:
  pop HL

  jp Main_Menu

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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Clear_Screen.asm"
  include "Shared/Calculate_Screen_Pixel_Address.asm"
  include "Shared/Calculate_Screen_Attribute_Address.asm"
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Udgs/Merge_Character.asm"
  include "Shared/Color_Line.asm"
  include "Shared/Browse_Key_Rows.asm"
  include "Shared/Unpress.asm"
  include "Shared/Delay.asm"
  include "Shared/Print_Character.asm"
  include "Shared/Print_String.asm"

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

;-------------------------------
; Storage for user defined keys
; The unique key code is stored
;-------------------------------
currently_defined_keys:
key_for_line_down:   defb  KEY_6
key_for_page_down:   defb  KEY_5
key_for_book_down:   defb  KEY_4
key_for_line_up:     defb  KEY_7
key_for_page_up:     defb  KEY_8
key_for_book_up:     defb  KEY_9
key_to_quit          defb  KEY_0
NUMBER_OF_UDKS  equ  7            ; number of user defined keys

text_currently_defined:  defb "Currently defined keys:", 0

text_current_address_table:
  defw text_current_line_down
  defw text_current_page_down
  defw text_current_book_down
  defw text_current_line_up
  defw text_current_page_up
  defw text_current_book_up
  defw text_current_quit

text_current_line_down:  defb "Line (   8 B) UP   [ ]", 0
text_current_page_down:  defb "Page ( 128 B) UP   [ ]", 0
text_current_book_down:  defb "Book (1024 B) UP   [ ]", 0
text_current_line_up:    defb "Line (   8 B) DOWN [ ]", 0
text_current_page_up:    defb "Page ( 128 B) DOWN [ ]", 0
text_current_book_up:    defb "Book (1024 B) DOWN [ ]", 0
text_current_quit:       defb "Quit the program   [ ]", 0
                             ;                     ^
                             ;                     |
CURRENT_KEY_COLUMN  equ  21  ; it is here ==-------+

text_press_01:  defb "[B]: Browse memory",        0
text_press_02:  defb "[D]: Define keys",          0
text_press_03:  defb "[Q]: Quit the utility",     0

text_prompt_address_table:
  defw text_prompt_line_up
  defw text_prompt_page_up
  defw text_prompt_book_up
  defw text_prompt_line_down
  defw text_prompt_page_down
  defw text_prompt_book_down
  defw text_prompt_quit

text_prompt_line_up:    defb "Press key for line UP    [ ]", 0
text_prompt_page_up:    defb "Press key for page UP    [ ]", 0
text_prompt_book_up:    defb "Press key for book UP    [ ]", 0
text_prompt_line_down:  defb "Press key for line DOWN  [ ]", 0
text_prompt_page_down:  defb "Press key for page DOWN  [ ]", 0
text_prompt_book_down:  defb "Press key for book DOWN  [ ]", 0
text_prompt_quit:       defb "Press key to quit        [ ]", 0
                            ;                           ^
                            ;                           |
PROMPT_KEY_COLUMN  equ  26  ; it is here ==-------------+

;----------------------------
; Hex numbers in narrow form
;----------------------------
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

;-------------------------
; Non-printable character
;-------------------------
empty: defb %00000000
       defb %01010100
       defb %00101010
       defb %01010100
       defb %00101010
       defb %01010100
       defb %00101010
       defb %00000000

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
; (Without label "Main", you could have written: SAVESNA "bojan.sna", $8000)
;-------------------------------------------------------------------------------
  savesna "bojan_014.sna", Main
  savebin "bojan_014.bin", Main, $ - Main

