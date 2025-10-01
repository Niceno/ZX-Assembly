;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   INCLUDE STATEMENTS
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Constants.inc"
  include "Include/Macros.inc"

;===============================================================================
; Main_Menu
;-------------------------------------------------------------------------------
; Purpose:
; - The game's main menu.  Sets colors, print currently defined set of keys
;   and prompts a user wheather he wants to refedine the keys or just play
;
; Parameters:
; - none
;
; Global variables used:
; - text_current
; - text_current_address_table
;
; Calls:
; - Set_Border_Color
; - Unpress
; - Clear_Screen
; - Print_String
; - Print_Udgs_Character
; - Browse_Key_Rows_For_One_Key
;-------------------------------------------------------------------------------
Main_Menu:

  ;---------------
  ; Set the color
  ;---------------
  ld A, BLACK_INK + CYAN_PAPER    ; load A with desired color
  ld (MEM_STORE_SCREEN_COLOR), A  ; set the screen colors

  ;----------------------
  ; Set the border color
  ;----------------------
  ld A, CYAN_INK             ; load A with desired color
  call Set_Border_Color

  call Unpress  ; unpress first

  ld A, (MEM_STORE_SCREEN_COLOR)  ; set color into A
  call Clear_Screen               ; clear the screen

  ld B, 0 : ld C, 0
  ld HL, text_current
  call Print_String

  ;----------------------------
  ;
  ; Loop to print defined keys
  ;
  ;----------------------------
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

    ld HL, five_defined_keys
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
    add A,  2
    ld  B,  A      ; row
    ld  C, 16      ; column
    call Print_Udgs_Character

    pop BC   ; retreive the counter ...
    inc C    ; ... increase it ...
    ld A, C  ; ... and via accumulator ...
    cp 5     ; ... compare with 5

  jr nz, .loop_to_print_defined_keys    ; loop until we've taken 5 presses

  ;---------------------------------------
  ;
  ; Press R to redefine keys or P to play
  ;
  ;---------------------------------------
  ld HL, text_press_r_or_p
  ld B, 21 : ld C, 0
  call Print_String

.wait_for_keys_r_or_p

    call Browse_Key_Rows_For_One_Key  ; A = code, C bit0 = 1 if pressed

    cp KEY_R                          ; is the key "R" pressed?  Set z if so
    call z, Define_Keys

    cp KEY_P                          ; is the key "P" pressed?  Set z if so
    call z, Play_The_Game

    jr .wait_for_keys_r_or_p

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Define_Keys.asm"
  include "Play_The_Game.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Clear_Screen.asm"
  include "Shared/Set_Border_Color.asm"
  include "Shared/Print_String.asm"
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Browse_Key_Rows_For_One_Key.asm"
  include "Shared/Unpress.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   UTILITIES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Utilities/Merge_Grid.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   GLOBAL DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;----------------------------------------------------------------
; Storage for user defined keys  (The unique key code is stored)
;----------------------------------------------------------------
five_defined_keys:
key_for_up:     defb  KEY_Q
key_for_down:   defb  KEY_A
key_for_left:   defb  KEY_O
key_for_right:  defb  KEY_P
key_for_fire:   defb  KEY_M

;-------------------------------------------------------
; Lines of text used to list the currently defined keys
;-------------------------------------------------------
text_current:  defb "Currently defined keys:", 0

text_current_address_table:
  defw text_current_up
  defw text_current_down
  defw text_current_left
  defw text_current_right
  defw text_current_fire

text_current_up:     defb "Key for UP    [ ]", 0
text_current_down:   defb "Key for DOWN  [ ]", 0
text_current_left:   defb "Key for LEFT  [ ]", 0
text_current_right:  defb "Key for RIGHT [ ]", 0
text_current_fire:   defb "Key for FIRE  [ ]", 0

text_press_r_or_p:  defb "[R]: redefine keys [P]: play", 0

;-------------------------
; Definition of the world
;-------------------------
  include "World_003.inc"

