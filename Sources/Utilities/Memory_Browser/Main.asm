  define __MEMORY_BROWSER_MAIN__

;===============================================================================
; Memory_Browser_Main
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

  ;---------------------------------------------------
  ; Print ten times using subroutine Print_String
  ;---------------------------------------------------
  ld IX, text_key_lines_address_table  ; IX -> the address of lines' addresses
.loop:

    ; Load the line address into HL
    ld L, (IX+0)
    ld H, (IX+1)

    ; Print one line of text
    push BC            ; store the counter; Print_String clobbers the registers
    ld A, B : add A : ld B, A
    call Print_String
    pop BC             ; restore the counter

    ; Next table entry
    inc IX
    inc IX

    ; Increase loop count
    inc B
    ld A, B
    cp 8       ; if A is equal to ten, zero flag will be set

  jr nz, .loop  ; if flag is not set, A (and B) didn't reach eight yet

  ;--------------------------------------------------
  ;
  ; Press B to browse, D to define keys or Q to quit
  ;
  ;--------------------------------------------------
  ld HL, text_press_b : ld B, 19 : ld C, 0 : call Print_String
  ld HL, text_press_q : ld B, 21 : ld C, 0 : call Print_String

.wait_for_keys_b_or_q
    call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed
    cp KEY_B                  ; is the key "B" pressed?  Set z if so
    call z, Browse_Memory
    cp KEY_Q                  ; is the key "Q" pressed?  Set z if so
    ret z
    jr .wait_for_keys_b_or_q

  ret  ; end of Main_Menu

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
key_for_line_down:   defb  KEY_6
key_for_page_down:   defb  KEY_5
key_for_book_down:   defb  KEY_4
key_for_line_up:     defb  KEY_7
key_for_page_up:     defb  KEY_8
key_for_book_up:     defb  KEY_9
key_to_quit          defb  KEY_0

text_key_lines_address_table:  ; this is a good name, try to stick to it
  defw text_key_line_01, text_key_line_02, text_key_line_03, text_key_line_04
  defw text_key_line_05, text_key_line_06, text_key_line_07, text_key_line_08

text_key_line_01:  defb "Keys for browsing memory:",    0
text_key_line_02:  defb "  Line DOWN [6]",              0
text_key_line_03:  defb "  Page DOWN [5]",              0
text_key_line_04:  defb "  1 KB DOWN [4]",              0
text_key_line_05:  defb "  Line UP   [7]",              0
text_key_line_06:  defb "  Page UP   [8]",              0
text_key_line_07:  defb "  1 KB UP   [9]" ,             0
text_key_line_08:  defb "  Stop",                       0

text_press_b:  defb "[B]: Browse memory",        0
text_press_q:  defb "[Q]: Quit the utility",     0

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
