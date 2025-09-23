;===============================================================================
; Memory_Browser_Main_Menu
;-------------------------------------------------------------------------------
; Purpose:
; - draws “defined keys” page
; - waits for D or R
; - dispatches by calling another sub
; - returns to caller (Main)
;-------------------------------------------------------------------------------
Memory_Browser_Main:

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
  include "Browse_Memory.asm"
  include "Dump_Memory.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;   At this point, the shared subroutines used by all local subroutines are
;   included here.  At the point I created this directory, it seemed simpler.
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Clear_Screen.asm"
  include "Shared/Delay.asm"
  include "Shared/Unpress.asm"
  include "Shared/Draw_Frame.asm"
  include "Shared/Print_String.asm"
  include "Shared/Color_Line.asm"
  include "Shared/Udgs/Merge_Character.asm"
  include "Shared/Browse_Key_Rows.asm"
  include "Shared/Print_Hex_Byte.asm"

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
