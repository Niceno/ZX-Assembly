;===============================================================================
; Memory_Browser_Main_Menu
;-------------------------------------------------------------------------------
; Purpose:
; - draws “defined keys” page
; - waits for D or R
; - dispatches by calling another sub
; - returns to caller (Main)
;-------------------------------------------------------------------------------
Memory_Browser_Main_Menu:

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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Define_Keys.asm"
  include "Print_Narrow_Hex_Digit.asm"
  include "Merge_Narrow_Hex_Digit.asm"
  include "Print_Hex_Byte.asm"
  include "Browse_Memory.asm"
  include "Dump_Memory.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "../../Shared/Clear_Screen.asm"
  include "../../Shared/Delay.asm"
  include "../../Shared/Calculate_Screen_Attribute_Address.asm"
  include "../../Shared/Calculate_Screen_Pixel_Address.asm"
  include "../../Shared/Unpress.asm"
  include "../../Shared/Draw_Frame.asm"
  include "../../Shared/Print_Character.asm"
  include "../../Shared/Print_String.asm"
  include "../../Shared/Color_Line.asm"
  include "../../Shared/Udgs/Merge_Character.asm"
  include "../../Shared/Udgs/Print_Character.asm"
  include "../../Shared/Udgs/Print_Line_Tile.asm"
  include "../../Shared/Udgs/Print_Tile.asm"
  include "../../Shared/Browse_Key_Rows.asm"

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

text_current_line_down:  defb "Line DOWN [ ]", 0
text_current_page_down:  defb "Page DOWN [ ]", 0
text_current_book_down:  defb "1 KB DOWN [ ]", 0
text_current_line_up:    defb "Line UP   [ ]", 0
text_current_page_up:    defb "Page UP   [ ]", 0
text_current_book_up:    defb "1 KB UP   [ ]", 0
text_current_quit:       defb "Stop      [ ]", 0
                             ;            ^
                             ;            |
CURRENT_KEY_COLUMN  equ  12  ; here =-----+

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

text_prompt_line_up:    defb "Key for line DOWN [ ]", 0
text_prompt_page_up:    defb "Key for page DOWN [ ]", 0
text_prompt_book_up:    defb "Key for 1 KB DOWN [ ]", 0
text_prompt_line_down:  defb "Key for line UP   [ ]", 0
text_prompt_page_down:  defb "Key for page UP   [ ]", 0
text_prompt_book_down:  defb "Key for 1 KB UP   [ ]", 0
text_prompt_quit:       defb "Key to stop       [ ]", 0
                            ;                    ^
                            ;                    |
PROMPT_KEY_COLUMN  equ  12  ; it is here ==------+

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
