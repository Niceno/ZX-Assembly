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
  call Print_Hor_String

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
    cp 0 : jr z, .waits_the_key_for_up
    cp 1 : jr z, .waits_the_key_for_down
    cp 2 : jr z, .waits_the_key_for_left
    cp 3 : jr z, .waits_the_key_for_right
    cp 4 : jr z, .waits_the_key_for_fire

.waits_the_key_for_up:
    ld HL, arrow_up
    jr .now_print_the_symbol

.waits_the_key_for_down:
    ld HL, arrow_down
    jr .now_print_the_symbol

.waits_the_key_for_left:
    ld HL, arrow_left
    jr .now_print_the_symbol

.waits_the_key_for_right:
    ld HL, arrow_right
    jr .now_print_the_symbol

.waits_the_key_for_fire:
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
    ld A, MAGENTA_INK + YELLOW_PAPER + FLASH  ; color of the string
    ld C, 5                                   ; B should hold the row
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
                                        ; C bit 0 = 1 if any key pressed
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
    ld A, MAGENTA_INK + YELLOW_PAPER  ; color of the string
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
  call Print_Hor_String

  ld BC, $1503              ; set row (D) to 15 and column (E) to 3
  ld HL, text_press_fire    ; the address of the text to print in HL
  call Print_Hor_String

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

  ;-------------------------------------------
  ;
  ; Show the number of keys which are pressed
  ;
  ;-------------------------------------------

  ld BC, $0200                 ; row and column
  ld H, 0                      ; zero out H, so HL = 0x00XX
  ld A, (pressed_keys_record)  ; read the single byte into A
  ld L, A                      ; put the value into L
  call Print_08_Bit_Number
  ld A,  YELLOW_PAPER + MAGENTA_INK
  ld BC,  $0200
  ld DE,  $0103
  call Color_Tile

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
.browse_the_keys

  call Browse_Key_Rows_For_Three_Keys
  ld DE, pressed_keys_record
  ld A, (DE)                   ; load number of pressed keys into A
  cp 0

  jp z, .main_game_loop  ; no key pressed -> keep polling

  ld B, A  ; put the number of pressed keys into B
  ld C, 0  ; set direction code to 0

  ;-----------------------------------------------
  ;
  ; If you are here, at least one key was pressed
  ;
  ;-----------------------------------------------
.carry_on
    inc DE      ; first (next?) key
    ld  HL, five_defined_keys
    ld A, (DE)  ; unique code of the first (next?) key

    ;-----------------
    ; Up: 1     (2^0)
    ;-----------------
    cp (HL) : inc HL
    jr nz, .key_for_up_was_not_pressed
      set 0, C  ; goes up, C is 1
.key_for_up_was_not_pressed

    ;-----------------
    ; Down: 2   (2^1)
    ;-----------------
    cp (HL) : inc HL
    jr nz, .key_for_down_was_not_pressed
      set 1, C  ; goes up,        C is 2
                ; goes up + down, C is 3 <--= don't use that
.key_for_down_was_not_pressed

    ;-----------------
    ; Left: 4   (2^2)
    ;-----------------
    cp (HL) : inc HL
    jr nz, .key_for_left_was_not_pressed
      set 2, C  ; goes left,        C is 4
                ; goes up + left,   C is 5
                ; goes down + left, C is 6
.key_for_left_was_not_pressed

    ;-----------------
    ; Right: 8  (2^3)
    ;-----------------
    cp (HL) : inc HL
    jr nz, .key_for_right_was_not_pressed
      set 3, C  ; goes right,        C is  8
                ; goes right + left, C is 12  <--= don't use that
                ; goes up + right,   C is  9
                ; goes down + right, C is 10
.key_for_right_was_not_pressed

  djnz .carry_on

  ;----------------------------------------------
  ; If no key was pressed, browse the keys again
  ;----------------------------------------------
  ld A, C
  cp 0
  jr z, .browse_the_keys

  ;----------------------------------------------
  ;
  ; One of keys was pressed, perform some action
  ;
  ;----------------------------------------------

  ;--------------------------------
  ; Clear the character's position
  ;--------------------------------
  push BC  ; store the key combination
  ld HL, empty
  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character
  pop BC   ; restore the key combination

  ;--------------------------------------
  ; Place the key combination in A again
  ;--------------------------------------
  ld A, C

  ;--------------------------------------------------------------
  ; Pick which action to take depending on which key was pressed
  ;--------------------------------------------------------------
  cp  1 : jp z, .key_for_up_was_pressed
  cp  2 : jp z, .key_for_down_was_pressed
  cp  4 : jp z, .key_for_left_was_pressed
  cp  8 : jp z, .key_for_right_was_pressed

  cp  5 : jp z, .keys_for_up_and_left_were_pressed
  cp  9 : jp z, .keys_for_up_and_right_were_pressed
  cp  6 : jp z, .keys_for_down_and_left_were_pressed
  cp 10 : jp z, .keys_for_down_and_right_were_pressed

  ;-------------------------------------------------------------
  ; No useful key combination was pressed, go back to main loop
  ;-------------------------------------------------------------
  jp .main_game_loop

.key_for_up_was_pressed:
  ld HL, hero_row : dec (HL)  ; decrease hero's row position on the map
  ld HL, arrow_up             ; set up the proper character
  jr .ready_to_print

.key_for_down_was_pressed:
  ld HL, hero_row : inc (HL)  ; increase hero's row position on the map
  ld HL, arrow_down           ; set up the proper character
  jr .ready_to_print

.key_for_left_was_pressed:
  ld HL, hero_col : dec(HL)  ; decrease hero's column position on the map
  ld HL, arrow_left          ; set up the proper character
  jr .ready_to_print

.key_for_right_was_pressed:
  ld HL, hero_col : inc (HL)  ; increase hero's column position on the map
  ld HL, arrow_right          ; set up the proper character
  jr .ready_to_print

.keys_for_up_and_left_were_pressed:
  ld HL, hero_row : dec (HL)  ; decrease hero's row position on the map
  ld HL, hero_col : dec (HL)  ; decrease hero's col position on the map
  ld HL, arrow_up_left        ; set up the proper character
  jr .ready_to_print

.keys_for_up_and_right_were_pressed:
  ld HL, hero_row : dec (HL)  ; decrease hero's row position on the map
  ld HL, hero_col : inc (HL)  ; increase hero's col position on the map
  ld HL, arrow_up_right       ; set up the proper character
  jr .ready_to_print

.keys_for_down_and_left_were_pressed:
  ld HL, hero_row : inc (HL)  ; increase hero's row position on the map
  ld HL, hero_col : dec (HL)  ; decrease hero's col position on the map
  ld HL, arrow_down_left      ; set up the proper character
  jr .ready_to_print

.keys_for_down_and_right_were_pressed:
  ld HL, hero_row : inc (HL)  ; increase hero's row position on the map
  ld HL, hero_col : inc (HL)  ; increase hero's col position on the map
  ld HL, arrow_down_right     ; set up the proper character
  jr .ready_to_print

.ready_to_print

  ld A, (hero_row) : ld B, A
  ld A, (hero_col) : ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1 : ld (hero_moved), A

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
  include "Shared/Print_Hor_String.asm"
  include "Shared/Udgs/Print_Character.asm"
  include "Shared/Delay.asm"
  include "Shared/Print_08_Bit_Number.asm"
  include "Shared/Browse_Key_Rows_For_Three_Keys.asm"

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
arrow_up:          defb  $00, $18, $3C, $7E, $18, $18, $18, $00
arrow_up_right:    defb  $00, $1E, $0E, $1E, $3A, $70, $20, $00
arrow_down:        defb  $00, $18, $18, $18, $7E, $3C, $18, $00
arrow_down_right:  defb  $00, $20, $70, $3A, $1E, $0E, $1E, $00
arrow_left:        defb  $00, $10, $30, $7E, $7E, $30, $10, $00
arrow_down_left:   defb  $00, $04, $0E, $5C, $78, $70, $78, $00
arrow_right:       defb  $00, $08, $0C, $7E, $7E, $0C, $08, $00
arrow_up_left:     defb  $00, $78, $70, $78, $5C, $0E, $04, $00
fire:              defb  $08, $04, $0C, $2A, $3A, $7A, $66, $3C
skull:             defb  $3E, $6D, $6D, $7B, $7F, $3E, $2A, $00
empty:             defb  $00, $00, $00, $00, $00, $00, $00, $00

udgs_arrows:  defw arrow_up

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "022_Define_Keys_Old.sna", Main
  savebin "022_Define_Keys_Old.bin", Main, $ - Main
