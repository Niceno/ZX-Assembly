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
  call ROM_SET_BORDER_COLOR

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

  call ROM_CLEAR_SCREEN           ; clear the screen

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
    ;
    ; Then the key
    ;
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
  ;
  ; Press R to redefine keys or P to play
  ;
  ;
  ;---------------------------------------
  ld HL, text_press_r_or_p
  ld B, 21 : ld C, 0
  call Print_String

.wait_for_keys_r_or_p

    call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed

    cp KEY_R                  ; is the key "R" pressed?  Set z if so
    call z, Define_Keys 

    cp KEY_P                  ; is the key "P" pressed?  Set z if so
    call z, Play_The_Game

    jr .wait_for_keys_r_or_p

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
    ld   C, 16                 ; set column
    call Print_Udgs_Character
    pop BC                     ; restore the counter

    ; Check if counter reached five
    inc C
    ld A, C
    cp 5

  jp nz, .define_five_keys          ; loop until we've taken 5 presses

  call Main_Menu

  ret  ; end of Define_Keys

;===============================================================================
; Play_The_Game
;-------------------------------------------------------------------------------
; Purpose:
; - Clears screen, runs main game loop
; - Returns to caller (menu) when done
;-------------------------------------------------------------------------------
Play_The_Game:

  call Unpress  ; unpress first

  call ROM_CLEAR_SCREEN           ; clear the screen

  ;-------------------------
  ;
  ;
  ; Prepare the main screen
  ;
  ;
  ;-------------------------

  ;---------------------
  ; Create the viewport
  ;---------------------
  ld A, WHITE_PAPER + BLUE_INK
  call Viewport_Create

  call Draw_The_World

  ;-----------------------------------
  ; Show hero at his initial position
  ;-----------------------------------
  ld HL, arrow_up
  ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
  call Print_Udgs_Character

  ;----------------
  ;
  ;
  ; Main game loop
  ;
  ;
  ;----------------
.main_game_loop:

    ; Fetch hero's coordinates and print them
    ld IX, hero_world_row : ld A, (IX+0)  ; place hero's world row into A
    ld H, 0 : ld L, A                     ; load HL pair with A (hero's row)
    ld B, 0 : ld C, 29                    ; set row and column
    call Print_08_Bit_Number              ; print it

    ld IX, hero_world_col : ld A, (IX+0)  ; place hero's world column into A
    ld H, 0 : ld L, A                     ; load HL pair with A (hero's column)
    ld B, 1 : ld C, 29                    ; set row and column
    call Print_08_Bit_Number              ; print it

    ; Fetch hero's offset coordinates and print them too
    ld IX, hero_row_offset : ld A, (IX+0)  ; place hero's row offset into A
    ld H, 0 : ld L, A                      ; load HL pair with A
    ld B, 3 : ld C, 29                     ; set row and column
    call Print_08_Bit_Number               ; print it

    ld IX, hero_col_offset : ld A, (IX+0)  ; place hero's column offset into A
    ld H, 0 : ld L, A                      ; load HL pair with A
    ld B, 4 : ld C, 29                     ; set row and column
    call Print_08_Bit_Number               ; print it

    ; Create a little delay
    ld B, 5
    call Delay

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

    ; Update coordinates
    ld A, (hero_world_row)  : dec A : ld (hero_world_row),  A
    ld A, (hero_row_offset) : dec A : ld (hero_row_offset), A

    ; Update sprite
    ld HL, arrow_up
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    jr .main_game_loop

    ;-----------------
    ; Action for down
    ;-----------------
.was_the_key_for_down_pressed:
    ld HL, key_for_down
    cp (HL)
    jr nz, .was_the_key_for_left_pressed

    ; Update coordinates
    ld A, (hero_world_row)  : inc A : ld (hero_world_row),  A
    ld A, (hero_row_offset) : inc A : ld (hero_row_offset), A

    ; Update sprite
    ld HL, arrow_down
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    jp .main_game_loop

    ;-----------------
    ; Action for left
    ;-----------------
.was_the_key_for_left_pressed:
    ld HL, key_for_left
    cp (HL)
    jr nz, .was_the_key_for_right_pressed

    ; Update coordinates
    ld A, (hero_world_col)  : dec A : ld (hero_world_col), A
    ld A, (hero_col_offset) : dec A : ld (hero_col_offset), A

    ; Update sprite
    ld HL, arrow_left
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    jp .main_game_loop

    ;------------------
    ; Action for right
    ;------------------
.was_the_key_for_right_pressed:
    ld HL, key_for_right
    cp (HL)
    jr nz, .was_the_key_for_fire_pressed

    ; Update coordinates
    ld A, (hero_world_col)  : inc A : ld (hero_world_col), A
    ld A, (hero_col_offset) : inc A : ld (hero_col_offset), A

    ; Update sprite
    ld HL, arrow_right
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    jp .main_game_loop

.was_the_key_for_fire_pressed:
    ld HL, key_for_fire
    cp (HL)
    jr nz, .were_all_keys_pressed

    ; Update sprite
    ld HL, fire
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    jp .main_game_loop

.were_all_keys_pressed:

  call Main_Menu

  ret  ; end of Play_The_Game

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Calculate_Screen_Attribute_Address.asm"
  include "Subs/Color_Line.asm"
  include "Subs/Color_Tile.asm"
  include "Subs/Draw_Frame.asm"
  include "Subs/Viewport/Create.asm"
  include "Subs/Viewport/Store_Data_For_Attributes.asm"
  include "Subs/Viewport/Store_Data_For_Pixels.asm"
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Udgs/Print_Character.asm"
  include "Subs/Udgs/Print_Line_Tile.asm"
  include "Subs/Udgs/Print_Tile.asm"
  include "Subs/Udgs/Print_Line_Sprite.asm"
  include "Subs/Udgs/Print_Sprite.asm"
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

; Hero's position and offset
hero_world_row:   defb  127
hero_world_col:   defb  127
hero_row_offset:  defb  127 - HERO_SCREEN_ROW
hero_col_offset:  defb  127 - HERO_SCREEN_COL

;-------------------------------
; Storage for user defined keys
; The unique key code is stored
;-------------------------------
five_defined_keys:
key_for_up:     defb  KEY_Q
key_for_down:   defb  KEY_A
key_for_left:   defb  KEY_O
key_for_right:  defb  KEY_P
key_for_fire:   defb  KEY_M

arrow_up:      defb $00, $18, $3C, $7E, $18, $18, $18, $00
arrow_down:    defb $00, $18, $18, $18, $7E, $3C, $18, $00
arrow_left:    defb $00, $10, $30, $7E, $7E, $30, $10, $00
arrow_right:   defb $00, $08, $0C, $7E, $7E, $0C, $08, $00
fire:          defb $08, $04, $0C, $2A, $3A, $7A, $66, $3C

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

text_prompt_address_table:
  defw text_prompt_for_up
  defw text_prompt_for_down
  defw text_prompt_for_left
  defw text_prompt_for_right
  defw text_prompt_for_fire

text_prompt_for_up:    defb "Press key for UP    [ ]", 0
text_prompt_for_down:  defb "Press key for DOWN  [ ]", 0
text_prompt_for_left:  defb "Press key for LEFT  [ ]", 0
text_prompt_for_right: defb "Press key for RIGHT [ ]", 0
text_prompt_for_fire:  defb "Press key for FIRE  [ ]", 0

;-------------------------
; Definition of the world
;-------------------------
world_address_table:
  dw tile_01_record
  dw tile_02_record
  dw tile_03_record
  dw tile_04_record
  dw $0000           ; this marks the end of the world

;--------------
; Tile records
;--------------
;                   row0  col0  row1  col1  color
tile_01_record:  db  128,  128,  130,  130, RED_PAPER
tile_02_record:  db  131,  131,  133,  133, CYAN_PAPER
tile_03_record:  db  128,  131,  130,  133, YELLOW_PAPER
tile_04_record:  db  131,  128,  133,  130, GREEN_PAPER


;===============================================================================
Draw_One_Tile:
;-------------------------------------------------------------------------------
; Purpose:
;
;
; Clobbers:
; - AF, HL, IX
;-------------------------------------------------------------------------------

  push HL  ; will pop up as IX later

  ;---------------------------------
  ; Work out the row and the column
  ;---------------------------------
  ld IX, hero_row_offset
  ld A, (HL) : sbc (IX+0) : ld B, A : inc HL  ; store screen row
  ld A, (HL) : sbc (IX+1) : ld C, A : inc HL  ; store screen column

  ;-------------------------
  ; Work out the dimensions
  ;-------------------------
  pop IX  ; point IX to the tile you are drawing now because you want ...
          ; ... to be able to work out the dimensions from the record
  ld A, (HL) : sbc (IX+0) : inc A : ld D, A : inc HL  ; dim. in rows
  ld A, (HL) : sbc (IX+1) : inc A : ld E, A : inc HL  ; dim. in columns
  ld A, (HL)  ; load the color

  call Color_Tile  ; A, BC and DE are the parameters

  ret

;===============================================================================
Draw_The_World:
;-------------------------------------------------------------------------------

  ;------------------------------
  ; Draw all the tiles in a loop
  ;------------------------------
  ld IX, world_address_table
.loop_the_world

    ld A,(IX+0)   ; load low byte
    or (IX+1)     ; OR with high byte
    jr z, .both_zero

    ld L, (IX+0)
    ld H, (IX+1)
    push IX
    call Draw_One_Tile
    pop IX

    inc IX
    inc IX

  jr .loop_the_world

.both_zero

  ret

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_008.sna", Main
  savebin "bojan_008.bin", Main, $ - Main
