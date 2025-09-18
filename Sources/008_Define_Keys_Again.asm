  include "Spectrum_Constants.inc"

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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; SECTION 0/X: PRINT DEFINED KEYS
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  ld B, 0 : ld C, 0
  ld HL, text_current
  call Print_String

  ;----------------------------
  ;
  ;
  ; Loop to print defined keys
  ;
  ;
  ;----------------------------
  ld C, 0

.loop_to_print_defined_keys

    ;----------------------
    ;
    ; First print the text
    ;
    ;----------------------
    push BC  ; save the counter

    ld L, C : ld H, 0    ; place C (count) in HL pair
    add  HL, HL          ; index * 2 (word table)
    ld   DE, text_current_table
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
    ;
    ; Then the key
    ;
    ;--------------
    push BC

    ld HL, five_defined_keys
    ld D, 0 : ld E, C         ; place counter into DE
    add HL, DE                ; add it as an offset to HL

    ld D, 0 : ld A, (HL) : ld E, A  ; load DE with the unique key code

    ld IX, all_characters_mem_coded  ; add DE twice to HL ...
    add IX, DE                       ; ... making it an offset from ...
    add IX, DE                       ; ... all_characters_mem_coded
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

  ;--------------------------------
  ;
  ;
  ; Press any key to continue loop
  ;
  ;
  ;--------------------------------
  call Press_Any_Key
  call Unpress        ; better be followed with "Unpress"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; SECTION 1/X: DEFINE KEYS
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  call ROM_CLEAR_SCREEN           ; clear the screen

  ;--------------------------
  ;
  ;
  ; Loop to define five keys
  ;
  ;
  ;--------------------------
  ld C, 0  ; need 5 keys

.define_five_keys:

    ;------------------------
    ;
    ; Print a prompting text
    ;
    ;------------------------
    push BC  ; keep the counter safe

    ld L, C : ld H, 0    ; place C (count) in HL pair
    add  HL, HL          ; index * 2 (word table)
    ld   DE, text_table
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
    ;
    ; Browse through all key rows
    ;
    ;-----------------------------
    push BC               ; save the counter in C (through five keys)
    call Browse_Key_Rows  ; A = unique code, C bit0 = 1 if any key pressed
    bit  0, C             ; check C register's zeroth bit
    pop BC                ; retreive the counter in C

    jr z, .define_five_keys   ; no key pressed -> keep polling

    ;---------------------------------------------------
    ;
    ; A key was pressed - wait untill it gets unpressed
    ;
    ;---------------------------------------------------
    push AF       ; keep unique code in A safe
    push BC       ; save the counter in C
    call Unpress  ; wait until all keys released
    pop BC        ; restore the counter in C
    pop AF        ; restore the unique code in A

    ;---------------------------
    ;
    ; Process the key in A here
    ;
    ;---------------------------

    ; Store the defined key ... very important!!!
    ld HL, five_defined_keys
    ld B, 0     ; with B set to zero, the pair BC will be the offset
    add HL, BC  ; add the offset to five defined keys
    ld (HL), A  ; store the key's unique code

    ; Print the key you just pressed ... quite handy
    ld IX, all_characters_mem_coded  ; point to all key characters table
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
    ld   C, 22                 ; set column
    call Print_Udgs_Character
    pop BC                     ; restore the counter

    ; Check if counter reached five
    inc C
    ld A, C
    cp 5

  jp nz, .define_five_keys          ; loop until we've taken 5 presses

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; SECTION 2/X: PLAY THE GAME
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  call ROM_CLEAR_SCREEN           ; clear the screen

  ;-------------------------
  ;
  ;
  ; Prepare the main screen
  ;
  ;
  ;-------------------------

  ;----------------
  ;
  ;
  ; Main game loop
  ;
  ;
  ;----------------
.main_game_loop:

    ;-----------------------------
    ;
    ; Browse through all key rows
    ;
    ;-----------------------------
    call Browse_Key_Rows  ; A = unique code, C bit0 = 1 if any key pressed
    bit  0, C             ; check C register's zeroth bit

    jr z, .main_game_loop  ; no key pressed -> keep polling

    ;---------------------------------------------
    ;
    ; A key was pressed - process the action here
    ; (Note that here A holds the unique key code)
    ;
    ;---------------------------------------------

    ;---------------
    ; Action for up
    ;---------------
.was_the_key_for_up_pressed:
    ld HL, key_for_up
    cp (HL)
    jr nz, .was_the_key_for_down_pressed

    ld HL, arrow_up
    ld B, 1 : ld C, 1
    call Print_Udgs_Character

    jr .main_game_loop

    ;-----------------
    ; Action for down
    ;-----------------
.was_the_key_for_down_pressed:
    ld HL, key_for_down
    cp (HL)
    jr nz, .was_the_key_for_left_pressed

    ld HL, arrow_down
    ld B, 1 : ld C, 1
    call Print_Udgs_Character

    jr .main_game_loop

    ;-----------------
    ; Action for left
    ;-----------------
.was_the_key_for_left_pressed:
    ld HL, key_for_left
    cp (HL)
    jr nz, .was_the_key_for_right_pressed

    ld HL, arrow_left
    ld B, 1 : ld C, 1
    call Print_Udgs_Character

    jr .main_game_loop

    ;------------------
    ; Action for right
    ;------------------
.was_the_key_for_right_pressed:
    ld HL, key_for_right
    cp (HL)
    jr nz, .was_the_key_for_fire_pressed

    ld HL, arrow_right
    ld B, 1 : ld C, 1
    call Print_Udgs_Character

    jr .main_game_loop

.was_the_key_for_fire_pressed:
    ld HL, key_for_fire
    cp (HL)
    jr nz, .were_all_keys_pressed

    ld HL, fire
    ld B, 1 : ld C, 1
    call Print_Udgs_Character

    jr .main_game_loop

.were_all_keys_pressed:

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; SECTION 3/X: GAME OVER
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  ei   ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Calculate_Screen_Attribute_Address.asm"
  include "Subs/Color_Line.asm"
  include "Subs/Press_Any_Key.asm"
  include "Subs/Unpress.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_String.asm"
  include "Subs/Udgs/Print_Character.asm"
  include "Subs/Delay.asm"
  include "Subs/Print_08_Bit_Number.asm"
  include "Subs/Browse_Key_Rows.asm"

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
five_defined_keys:
key_for_up:     defb  KEY_7
key_for_down:   defb  KEY_6
key_for_left:   defb  KEY_5
key_for_right:  defb  KEY_8
key_for_fire:   defb  KEY_0

arrow_up:      defb $00, $18, $3C, $7E, $18, $18, $18, $00
arrow_down:    defb $00, $18, $18, $18, $7E, $3C, $18, $00
arrow_left:    defb $00, $10, $30, $7E, $7E, $30, $10, $00
arrow_right:   defb $00, $08, $0C, $7E, $7E, $0C, $08, $00
fire:          defb $08, $04, $0C, $2A, $3A, $7A, $66, $3C

text_current:  defb "Currently defined keys:", 0

text_current_table:
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

text_table:
  defw text_for_up
  defw text_for_down
  defw text_for_left
  defw text_for_right
  defw text_for_fire

text_for_up:    defb "Press key for UP    [ ]", 0
text_for_down:  defb "Press key for DOWN  [ ]", 0
text_for_left:  defb "Press key for LEFT  [ ]", 0
text_for_right: defb "Press key for RIGHT [ ]", 0
text_for_fire:  defb "Press key for FIRE  [ ]", 0

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_008.sna", Main
  savebin "bojan_008.bin", Main, $ - Main
