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
;   MAIN PROGRAM
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

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

  call Main_Menu

  ei   ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret  ; end of the main program

;===============================================================================
; Main_Menu
;-------------------------------------------------------------------------------
; Purpose:
; - draws “defined keys” page
; - waits for R or P
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

    pop BC              ; retreive the counter ...
    inc C              ; ... increase it ...
    ld A, C            ; ... and via accumulator ...
    cp NUMBER_OF_UDKS  ; ... compare with NUMBER_OF_UDKS

  jr nz, .loop_to_print_defined_keys    ; loop until we've taken
                                        ; NUMBER_OF_UDKS presses

  ;------------------------------------
  ;
  ; Press D to define keys or R to run
  ;
  ;------------------------------------
  ld HL, text_press_d_or_r
  ld B, 21 : ld C, 0
  call Print_String

.wait_for_keys_d_or_r

    call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed

    cp KEY_D                  ; is the key "D" pressed?  Set z if so
    call z, Define_Keys

;   cp KEY_P                  ; is the key "R" pressed?  Set z if so
;   call z, Play_The_Game

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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Clear_Screen.asm"
  include "Subs/Set_Border_Color.asm"
  include "Subs/Calculate_Screen_Attribute_Address.asm"
  include "Subs/Color_Line.asm"
  include "Subs/Color_Tile.asm"
  include "Subs/Draw_Frame.asm"
  include "Subs/Viewport/Create.asm"
  include "Subs/Viewport/Store_Data_For_Attributes.asm"
  include "Subs/Viewport/Store_Data_For_Pixels.asm"
  include "Subs/Viewport/Scroll_Attributes_Up.asm"
  include "Subs/Viewport/Scroll_Attributes_Down.asm"
  include "Subs/Viewport/Scroll_Attributes_Left.asm"
  include "Subs/Viewport/Scroll_Attributes_Right.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Udgs/Print_Character.asm"
  include "Subs/Udgs/Print_Line_Tile.asm"
  include "Subs/Udgs/Print_Tile.asm"
  include "Subs/Udgs/Print_Line_Sprite.asm"
  include "Subs/Udgs/Print_Sprite.asm"
  include "Subs/Udgs/Merge_Line_Sprite.asm"
  include "Subs/Udgs/Merge_Sprite.asm"
  include "Subs/Merge_Grid.asm"
  include "Subs/Browse_Key_Rows.asm"
  include "Subs/Press_Any_Key.asm"
  include "Subs/Unpress.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_String.asm"
  include "Subs/Delay.asm"
  include "Subs/Print_08_Bit_Number.asm"

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

text_press_d_or_r:  defb "[D]: define keys [R]: run", 0

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

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_008_define_keys.sna", Main
  savebin "bojan_008_define_keys.bin", Main, $ - Main

