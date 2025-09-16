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

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld HL, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), HL  ; set up UDG system variable.

  ;----------------------
  ; Set the border color
  ;----------------------
  ld A, CYAN_INK              ; load A with desired color
  call ROM_SET_BORDER_COLOR

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
  call Color_Line

  ;--------------------------
  ;
  ;
  ; Loop to define five keys
  ;
  ;
  ;--------------------------
  ld B, 5  ; you will define five keys

.loop_to_define_keys:
    push BC  ; store the counter

    ;----------------------------------------------------------
    ; Print a little yellow flashing arrow for the entry
    ; and set the "pointers" curr_port_addr and curr_mask_addr
    ;----------------------------------------------------------
    ld A, B
    cp 5
    jr z, .pressed_the_key_for_up
    cp 4
    jr z, .pressed_the_key_for_down
    cp 3
    jr z, .pressed_the_key_for_left
    cp 2
    jr z, .pressed_the_key_for_right
    cp 1
    jr z, .pressed_the_key_for_fire

.pressed_the_key_for_up:
    ld HL, arrow_up
    ld (udgs_arrows), HL
    ld HL, port_for_up
    ld (curr_port_addr), HL
    ld HL, mask_for_up
    ld (curr_mask_addr), HL
    jr .now_print_the_symbol

.pressed_the_key_for_down:
    ld HL, arrow_down
    ld (udgs_arrows), HL
    ld HL, port_for_down
    ld (curr_port_addr), HL
    ld HL, mask_for_down
    ld (curr_mask_addr), HL
    jr .now_print_the_symbol

.pressed_the_key_for_left:
    ld HL, arrow_left
    ld (udgs_arrows), HL
    ld HL, port_for_left
    ld (curr_port_addr), HL
    ld HL, mask_for_left
    ld (curr_mask_addr), HL
    jr .now_print_the_symbol

.pressed_the_key_for_right:
    ld HL, arrow_right
    ld (udgs_arrows), HL
    ld HL, port_for_right
    ld (curr_port_addr), HL
    ld HL, mask_for_right
    ld (curr_mask_addr), HL
    jr .now_print_the_symbol

.pressed_the_key_for_fire:
    ld HL, fire
    ld (udgs_arrows), HL
    ld HL, port_for_fire
    ld (curr_port_addr), HL
    ld HL, mask_for_fire
    ld (curr_mask_addr), HL

.now_print_the_symbol:

    ld A, (text_row)          ; get current row
    inc A                     ; icrease it ...
    inc A                     ; ... by two ...
    ld (text_row), A          ; ... and store it back
    ld B, A                   ; store it in B too
    ld C, 5

    ; Color that little box
    ld A, RED_INK + YELLOW_PAPER + FLASH  ; color of the string
    ld C, 5                               ; B should hold the row
    ld E, 1
    push BC
    call Color_Line
    pop BC

    ; This is where it finally prints the symbol
    ld HL, (udgs_arrows)
    call Print_Udgs_Character  ; at this point, prints arrow

    ;--------------------------------------------------------------------
    ; Wait until a key is pressed
    ;
    ; Just to make sure these constructs are clear:
    ; - We load the contents of a "KEYS_....." port into BC register
    ; - Then we read from the port addressed by BC, and stores the
    ;   result in A (this is what "in" command does.
    ; - Then we compare a particular bit of A using the bit command
    ;   (The bit command only modifies the Zero (Z) flag.
    ;    > If the tested bit is 1, the Z flag is reset to 0.
    ;    > If the tested bit is 0, the Z flag is set to 1.
    ; - When the zero flag is zero (i.e., key is pressed), we jump to
    ;   the label that handles printing that key.
    ;
    ; (It would be better to use "jr z, Address" here, but there
    ;  are simply too many keys now.  When it gets smaller again.)
    ;--------------------------------------------------------------------
.read_next_key:

      ;--------------------------------------
      ; Let IX point to all characters array
      ;--------------------------------------
      ld IX, all_characters_mem - 2  ; make sure first two increases ...
                                     ; ... points to all_characters

        ;-------------------------------------------------------------
      ; Set the HL to point to the beginning of array all_key_ports
      ;-------------------------------------------------------------
      ld HL, all_key_ports

      ;------------------------------
      ; There are eight rows of keys
      ;------------------------------
      ld D, 8              ; there are eight rows of keys

.browse_key_rows:

        ; Keyboard row; load the port number into BC indirectly through HL
        ld C, (HL)       ; low byte into C
        inc HL
        ld B, (HL)       ; high byte into B
        inc HL

        in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
        bit 0, A         ; bit 0
        ld A, %00000001  ; store bit 0
        inc IX
        inc IX
        jr z, .print_the_selected_key
        in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
        bit 1, A         ; bit 1
        ld A, %00000010  ; store bit 1
        inc IX
        inc IX
        jr z, .print_the_selected_key
        in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
        bit 2, A         ; bit 2
        ld A, %00000100  ; store bit 2
        inc IX
        inc IX
        jr z, .print_the_selected_key
        in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
        bit 3, A         ; bit 3
        ld A, %00001000  ; store bit 3
        inc IX
        inc IX
        jr z, .print_the_selected_key
        in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
        bit 4, A         ; bit 4
        ld A, %00010000  ; store bit 4
        inc IX
        inc IX
        jr z, .print_the_selected_key

        dec D

      jr nz, .browse_key_rows

    jr .read_next_key    ; if not pressed, repeat loop

    ;------------------------
    ; Print the selected key
    ;------------------------
.print_the_selected_key:

    ; Save port (BC already contains the port)
    ld HL, (curr_port_addr)
    ld (HL), C  ; low byte
    inc HL
    ld (HL), B  ; high byte

    ; Determine mask
    ld HL, (curr_mask_addr)
    ld (HL), A

    ld H, (IX+1)      ; address of the character to print
    ld L, (IX+0)      ; address of the character to print
    ld A, (text_row)  ; get current row
    ld B, A           ; store it in B
    ld C, 5           ; column is hard-coded
    call Print_Udgs_Character

    ld A, (text_row)  ; retreive the last row
    ld B, A
    ld C, 5
    ld E, 1
    ld A, RED_INK + YELLOW_PAPER  ; color of the string
    call Color_Line

    ;--------------------------------------
    ; Loop until all the keys are released
    ;--------------------------------------
    call Unpress

    ;--------------------------
    ; Retreive the key counter
    ;--------------------------
    pop BC

    dec B
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
  call ROM_CLEAR_SCREEN           ; clear the screen

  ;------------------------------
  ;
  ; Try to set initial character
  ;
  ;------------------------------

  ; This selects a character; just an arrow up for the time being
  ld HL, arrow_up
  ld (udgs_arrows), HL

  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  ld HL, (udgs_arrows)
  push BC
  call Print_Udgs_Character
  pop BC
  ld E, 1
  ld A, WHITE_PAPER + BRIGHT
  call Color_Line

  ;----------------
  ;
  ;
  ; Main game loop
  ;
  ;
  ;----------------
.main_game_loop:

  ld B, 1
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
  ld BC, $0000         ; row and column
  ld H, 0              ; zero out H, so HL = 0x00XX
  ld A, (hero_row)     ; read the single byte into A
  ld L, A              ; put the value into L
  call Print_08_Bit_Number
  ld BC, $0100         ; row and column
  ld H, 0              ; zero out H, so HL = 0x00XX
  ld A, (hero_column)  ; read the single byte into A
  ld L, A              ; put the value into L
  call Print_08_Bit_Number
  ld A,  CYAN_PAPER
  ld BC, $0000
  ld E,  2
  call Color_Line

.hero_not_moved:
  ld A, 0
  ld (hero_moved), A

  ;-------------------
  ;
  ; Read the UDKs now
  ;
  ;-------------------

  ;-------------------------------------------------------------------------
  ; Set the HL to point to the beginning of array of user defind keys (UDK)
  ;-------------------------------------------------------------------------
  ld HL, port_for_up  ; must be the first of ports for user defined keys

  ;---------------------------------------------------------------
  ; There are eight rows of keys, but you care about one only now
  ;---------------------------------------------------------------

  ld D, 5  ; you want five rows for five UDKs
.browse_keys_in_game:

    ; Keyboard row; load the port number into BC indirectly through HL
    ld C, (HL)      ; low byte into C
    inc HL
    ld B, (HL)      ; high byte into B
    inc HL

    ; You care about one key only, the one you defined for fire
    in A, (C)       ; read key states (1 = not pressed, 0 = pressed)

    ; Load the mask for this UDK
    ld B, (HL)
    inc HL

    ; ... and compare that mask (in B) with A
    and B

    jr z, .a_control_key_was_pressed

    dec D
  jr nz, .browse_keys_in_game  ; if D is not zero, browse keys again

  ; No control keys are pressed, go back to the main loop
  jr .main_game_loop

;------------------------------------------------------
; One of control keys was pressed, perform some action
;------------------------------------------------------
.a_control_key_was_pressed:

  ; Pick which action to take depending on which key was pressed
  ld A, D
  cp 5     ; upp is pressed
  jp z, .key_for_up_was_pressed_in_game
  cp 4     ; down is pressed
  jp z, .key_for_down_was_pressed_in_game
  cp 3     ; left is pressed
  jp z, .key_for_left_was_pressed_in_game
  cp 2     ; right is pressed
  jp z, .key_for_right_was_pressed_in_game
  cp 1
  jp z, .main_game_loop

.key_for_up_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  ; Decrease hero's row position on the map
  ld A, (hero_row)
  dec A
  ld (hero_row), A
  cp 0
  jp z, .main_game_over

  ; Set up the character for up
  ld HL, arrow_up
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1
  ld (hero_moved), A

  jp .main_game_loop  ; continue the main game loop, through key rows

.key_for_down_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  ; Increase hero's row position on the map
  ld A, (hero_row)
  inc A
  cp CELL_ROWS
  jp z, .main_game_over
  ld (hero_row), A

  ; Set up the character for down
  ld HL, arrow_down
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1
  ld (hero_moved), A

  jp .main_game_loop  ; continue the main game loop, through key rows

.key_for_left_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  ; Decrease hero's column position on the map
  ld A, (hero_column)
  dec A
  ld (hero_column), A
  cp 0
  jp z, .main_game_over

  ; Set up the character for left
  ld HL, arrow_left
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  ; Remember that hero moved
  ld A, 1
  ld (hero_moved), A

  jp .main_game_loop  ; continue the main game loop, through key rows

.key_for_right_was_pressed_in_game:

  ; Clear the character's position
  ld HL, empty
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  ; Increase hero's column position on the map
  ld A, (hero_column)
  inc A
  cp CELL_COLS
  jp z, .main_game_over
  ld (hero_column), A

  ; Set up the character for right
  ld HL, arrow_right
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
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
  ld A, (hero_row)
  ld B, A
  ld A, (hero_column)
  ld C, A
  call Print_Udgs_Character

  di  ; <--= (re)enable interrupts if you want to return to OS/BASIC

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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

;-----------------------------------
; Variables which define text boxes
;-----------------------------------
text_row:     defb  0  ; defb = define byte

; Hero's position
hero_row:    defb  10
hero_column: defb  10
hero_moved:  defb   0

;---------------------
; Texts to be written
;---------------------
text_press_a_key:   defb "Press keys for ", 0
text_keys_defined:  defb "All keys defined", 0
text_press_fire:    defb "Press any key to continue", 0
text_up:            defb "up",               0
text_down:          defb "down",             0
text_left:          defb "left",             0
text_right:         defb "down",             0
text_fire:          defb "fire",             0

;----------------------------------------------------------------
; The addresses of all characters you can get from Spectrum keys
; (Standard ones are taken from ROM, but some had to be replaced
;  by UDGs, of course)
;----------------------------------------------------------------
all_characters_mem:
; Ordered by their bit positions in keyboard ports
  defw MEM_1,      MEM_2,      MEM_3,      MEM_4,      MEM_5
  defw MEM_0,      MEM_9,      MEM_8,      MEM_7,      MEM_6      ; reversed
  defw MEM_Q_UPP,  MEM_W_UPP,  MEM_E_UPP,  MEM_R_UPP,  MEM_T_UPP
  defw MEM_P_UPP,  MEM_O_UPP,  MEM_I_UPP,  MEM_U_UPP,  MEM_Y_UPP  ; reversed
  defw MEM_A_UPP,  MEM_S_UPP,  MEM_D_UPP,  MEM_F_UPP,  MEM_G_UPP
  defw mem_ente,   MEM_L_UPP,  MEM_K_UPP,  MEM_J_UPP,  MEM_H_UPP  ; reversed
  defw mem_caps,   MEM_Z_UPP,  MEM_X_UPP,  MEM_C_UPP,  MEM_V_UPP
  defw mem_spac,   mem_symb,   MEM_M_UPP,  MEM_N_UPP,  MEM_B_UPP  ; reversed

;-----------------------------------------------------------
; User defined graphics (start at $90, then go $91, $92 ...
;-----------------------------------------------------------
udgs:

mem_ente:  defb $00, $02, $12, $32, $7E, $30, $10, $00
mem_caps:  defb $00, $10, $38, $7C, $10, $10, $10, $00
mem_symb:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00
mem_spac:  defb $00, $00, $00, $00, $00, $42, $7E, $00
;1 arrow_up:      defb $18, $24, $42, $C3, $24, $24, $24, $3C  ; $94
;1 arrow_down:    defb $3C, $24, $24, $24, $C3, $42, $24, $18  ; $95
;1 arrow_left:    defb $10, $30, $4F, $81, $81, $4F, $30, $10  ; $96
;1 arrow_right:   defb $08, $0C, $F2, $81, $81, $F2, $0C, $08  ; $97
;1 fire:          defb $99, $00, $3C, $A5, $A5, $3C, $00, $99  ; $98
arrow_up:      defb $00, $18, $3C, $7E, $18, $18, $18, $00 ; $94
arrow_down:    defb $00, $18, $18, $18, $7E, $3C, $18, $00 ; $95
arrow_left:    defb $00, $10, $30, $7E, $7E, $30, $10, $00 ; $96
arrow_right:   defb $00, $08, $0C, $7E, $7E, $0C, $08, $00 ; $97
fire:          defb $08, $04, $0C, $2A, $3A, $7A, $66, $3C ; $98
skull:         defb $3E, $6D, $6D, $7B, $7F, $3E, $2A, $00 ; $99
empty:         defb $00, $00, $00, $00, $00, $00, $00, $00 ; $A0 ?

udgs_arrows:  defw arrow_up

; User refined keys will be stored here
debug_begin: defb ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
port_for_up:    defw  0
mask_for_up:    defb  0
port_for_down:  defw  0
mask_for_down:  defb  0
port_for_left:  defw  0
mask_for_left:  defb  0
port_for_right: defw  0
mask_for_right: defb  0
port_for_fire:  defw  0
mask_for_fire:  defb  0
debug_end: defb "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

; Current port and mask addresses
curr_port_addr: defw 0
curr_mask_addr: defw 0

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_008.sna", Main
  savebin "bojan_008.bin", Main, $ - Main
