  include "Include/Constants.inc"

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

  ;----------------------
  ; Set the border color
  ;----------------------
  ld A, CYAN_INK              ; load A with desired color
  call Set_Border_Color:

  ;--------------------------------------------
  ; Print text "Press a key for" at 3, 3
  ;--------------------------------------------
  ld A, 3                  ; row
  ld (text_row), A         ; store row coordinate
  ld B, A                  ; put row in B
  ld C, 3                  ; set column too
  ld HL, text_press_a_key  ; the address of the text to print in HL
  call Print_String

  ; Color the text box
  ld A,  BLUE_INK + WHITE_PAPER
  ld B,  3         ; row
  ld C,  3         ; column
  ld E, 14         ; length
  call Color_Hor_Line

  ;--------------------------
  ;
  ;
  ; Loop to define five keys
  ;
  ;
  ;--------------------------
  ld A, 0  ; you will define five keys

.loop_to_define_keys:
    push AF  ; store the counter

    ;----------------------------------------------------------
    ; Print a little yellow flashing arrow for the entry
    ; and set the "pointers" curr_port_addr and curr_mask_addr
    ;----------------------------------------------------------
    cp 0 : jr z, .pressed_the_key_for_up
    cp 1 : jr z, .pressed_the_key_for_down
    cp 2 : jr z, .pressed_the_key_for_left
    cp 3 : jr z, .pressed_the_key_for_right
    cp 4 : jr z, .pressed_the_key_for_fire

.pressed_the_key_for_up:
    ld HL, arrow_up
    jr .now_print_the_symbol

.pressed_the_key_for_down:
    ld HL, arrow_down
    jr .now_print_the_symbol

.pressed_the_key_for_left:
    ld HL, arrow_left
    jr .now_print_the_symbol

.pressed_the_key_for_right:
    ld HL, arrow_right
    jr .now_print_the_symbol

.pressed_the_key_for_fire:
    ld HL, fire
    jr .now_print_the_symbol

.now_print_the_symbol:

    ld (udgs_arrows), HL

    ld A, (text_row)  ; get current row ...
    inc A : inc A     ; ... icrease it by two ...
    ld (text_row), A  ; ... and store it back
    ld B, A           ; store it in B too
    ld C, 5

    ; Color that little box
    ld A, RED_INK + YELLOW_PAPER + FLASH  ; color of the string
    ld C, 5                               ; B should hold the row
    ld E, 1
    push BC
    call Color_Hor_Line
    pop BC

    ; This is where it finally prints the symbol
    ld HL, (udgs_arrows)
    call Print_Udgs_Character  ; at this point, prints arrow

    ;-------------------------
    ; Browse through key rows
    ;-------------------------
.read_next_key:

      call Browse_Key_Rows_For_One_Key  ; A = unique code, ...
                                        ; ... C bit 0 = 1 if any key pressed
      bit  0, C                         ; check C register's zeroth bit

      jr z, .read_next_key  ; if not pressed, repeat loop

    ex AF, AF'  ; store the key code into AF'

    ;----------------------------------
    ; Store and print the selected key
    ;----------------------------------
.print_the_selected_key:

    ; Store the defined key ... very important!!!
    ld HL, five_defined_keys
    pop AF      ; retreive the loop counter
    ld C, A     ; put loop counter into C
    push AF     ; send the loop counter back
    ld B, 0     ; with B set to zero, the pair BC will be the key's offset
    add HL, BC  ; add the offset to five defined keys
    ex AF, AF'  ; get the key code back
    ld (HL), A  ; store the key's unique code

    ; Print the key you just pressed ... quite handy
    ld IX, key_glyphs_address_table  ; point to all key glyphs table
    ld D, 0                          ; create offset from unique key code ...
    ld E, A                          ; ... (stored in A) in the the DE pair
    add IX, DE                       ; add the offset ...
    add IX, DE                       ; ... to IX pair
    ld L, (IX+0)                     ; finally load HL with the address ...
    ld H, (IX+1)                     ; ... pointed to by IX

    ld A, (text_row)  ; get current row
    ld B, A           ; store it in B
    ld C, 5           ; column is hardcoded
    call Print_Udgs_Character

    ld A, (text_row)  ; retreive the last row
    ld B, A
    ld C, 5
    ld E, 1
    ld A, RED_INK + YELLOW_PAPER  ; color of the string
    call Color_Hor_Line

    ;--------------------------------------
    ; Loop until all the keys are released
    ;--------------------------------------
    call Unpress

    ;--------------------------
    ; Retreive the key counter
    ;--------------------------
    pop AF

    inc A
    cp 5   ; read it as: A = A - 5

  jp nz, .loop_to_define_keys

  ;-----------------------------------------------------------------------
  ; End the key definition stage with a message that all keys are defined
  ;-----------------------------------------------------------------------
  ld BC, $1303              ; set row (D) to 15 and column (E) to 3
  ld HL, text_keys_defined  ; the address of the text to print in HL
  call Print_String

  ld BC, $1503              ; set row (D) to 15 and column (E) to 3
  ld HL, text_press_fire    ; the address of the text to print in HL
  call Print_String

  ;--------------------------------
  ;
  ;
  ; Press any key to continue loop
  ;
  ;
  ;--------------------------------
  call Press_Any_Key

  ;--------------------------------------
  ; Loop until all the keys are released
  ;--------------------------------------
  call Unpress

  ;------------------
  ; Clear the screen
  ;------------------
  ld A, WHITE_PAPER
  call Clear_Screen

  ;------------------------------
  ;
  ; Try to set initial character
  ;
  ;------------------------------

  ; This selects a character; just an arrow up for the time being
  ld HL, arrow_up
  ld (udgs_arrows), HL

  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  ld HL, (udgs_arrows)
  push BC
  call Print_Udgs_Character
  pop BC
  ld E, 1
  ld A, WHITE_PAPER + BRIGHT
  call Color_Hor_Line

  ;----------------
  ;
  ;
  ; Main game loop
  ;
  ;
  ;----------------
.main_game_loop:

  ld B, 3
  call Delay

  ;------------------------------
  ;
  ; Show the position on the map
  ;
  ;------------------------------

  ;----------------------------
  ; Only print when hero moves
  ;----------------------------
  ld A, (hero_moved)
  cp 0
  jr z, .hero_not_moved

  ;--------------------
  ; Now print for real
  ;--------------------
  ld BC, $0000      ; row and column
  ld H, 0           ; zero out H, so HL = 0x00XX
  ld A, (hero_row)  ; read the single byte into A
  ld L, A           ; put the value into L
  call Print_08_Bit_Number
  ld BC, $0100      ; row and column
  ld H, 0           ; zero out H, so HL = 0x00XX
  ld A, (hero_col)  ; read the single byte into A
  ld L, A           ; put the value into L
  call Print_08_Bit_Number
  ld A,  CYAN_PAPER
  ld BC,  $0000
  ld DE,  $0203
  call Color_Tile

.hero_not_moved:
  ld A, 0
  ld (hero_moved), A

  ;-------------------
  ;
  ; Read the UDKs now
  ;
  ;-------------------

  call Browse_Key_Rows_For_One_Key  ; A = unique code, ...
                                    ; ... C bit0 = 1 if any key pressed
  bit  0, C                         ; check C register's zeroth bit

  jp z, .main_game_loop  ; no key pressed -> keep polling

  ;----------------------------------------------
  ; One of keys was pressed, perform some action
  ;----------------------------------------------

  ; Pick which action to take depending on which key was pressed
  ld HL, key_for_up    : cp (HL)  ; upp is pressed
  jp z, .key_for_up_was_pressed_in_game

  ld HL, key_for_down  : cp (HL)  ; down is pressed
  jp z, .key_for_down_was_pressed_in_game

  ld HL, key_for_left  : cp (HL)  ; left is pressed
  jp z, .key_for_left_was_pressed_in_game

  ld HL, key_for_right : cp (HL)  ; right is pressed
  jp z, .key_for_right_was_pressed_in_game

  jp .main_game_loop

.key_for_up_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  ; Decrease hero's row position on the map
  ld A, (hero_row)
  dec A
  ld (hero_row), A
  cp 0
  jp z, .main_game_over

  ; Set up the character for up
  ld HL, arrow_up
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1
  ld (hero_moved), A

  jp .main_game_loop  ; continue the main game loop, through key rows

.key_for_down_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  ; Increase hero's row position on the map
  ld A, (hero_row)
  inc A
  cp CELL_ROWS
  jp z, .main_game_over
  ld (hero_row), A

  ; Set up the character for down
  ld HL, arrow_down
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1
  ld (hero_moved), A

  jp .main_game_loop  ; continue the main game loop, through key rows

.key_for_left_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  ; Decrease hero's column position on the map
  ld A, (hero_col)
  dec A
  ld (hero_col), A
  cp 0
  jp z, .main_game_over

  ; Set up the character for left
  ld HL, arrow_left
  ld A, (hero_row)
  ld B, A
  ld A, (hero_col)
  ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1
  ld (hero_moved), A

  jp .main_game_loop  ; continue the main game loop, through key rows

.key_for_right_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  ; Increase hero's column position on the map
  ld A, (hero_col)
  inc A
  cp CELL_COLS
  jp z, .main_game_over
  ld (hero_col), A

  ; Set up the character for right
  ld HL, arrow_right
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) :  ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1
  ld (hero_moved), A

  jp .main_game_loop  ; continue the main game loop, through key rows

;-----------
;
; Game over
;
;-----------
.main_game_over

  ld HL, skull
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  di  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Set_Border_Color.asm"
  include "Shared/Clear_Screen.asm"
  include "Shared/Calculate_Screen_Attribute_Address.asm"
  include "Shared/Color_Tile.asm"
  include "Shared/Press_Any_Key.asm"
  include "Shared/Unpress.asm"
  include "Shared/Calculate_Screen_Pixel_Address.asm"
  include "Shared/Print_String.asm"
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Delay.asm"
  include "Shared/Print_08_Bit_Number.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

;-----------------------------------
; Variables which define text boxes
;-----------------------------------
text_row:     defb  0  ; defb = define byte

; Hero's position
hero_row:    defb  11
hero_col:    defb  15
hero_moved:  defb   0

;---------------------
; Texts to be written
;---------------------
text_press_a_key:   defb "Press keys for ",           0
text_keys_defined:  defb "All keys defined",          0
text_press_fire:    defb "Press any key to continue", 0
text_up:            defb "up",                        0
text_down:          defb "down",                      0
text_left:          defb "left",                      0
text_right:         defb "down",                      0
text_fire:          defb "fire",                      0

;----------------------------------------------------------------
; Storage for user defined keys  (The unique key code is stored)
;----------------------------------------------------------------
five_defined_keys:
key_for_up:     defb  KEY_Q
key_for_down:   defb  KEY_A
key_for_left:   defb  KEY_O
key_for_right:  defb  KEY_P
key_for_fire:   defb  KEY_M

;-----------------------
; User defined graphics
;-----------------------
arrow_up:      defb $00, $18, $3C, $7E, $18, $18, $18, $00
arrow_down:    defb $00, $18, $18, $18, $7E, $3C, $18, $00
arrow_left:    defb $00, $10, $30, $7E, $7E, $30, $10, $00
arrow_right:   defb $00, $08, $0C, $7E, $7E, $0C, $08, $00
fire:          defb $08, $04, $0C, $2A, $3A, $7A, $66, $3C
skull:         defb $3E, $6D, $6D, $7B, $7F, $3E, $2A, $00
empty:         defb $00, $00, $00, $00, $00, $00, $00, $00

udgs_arrows:  defw arrow_up

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "021_Define_Keys_Old.sna", Main
  savebin "021_Define_Keys_Old.bin", Main, $ - Main
