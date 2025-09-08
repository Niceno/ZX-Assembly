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
Main_Sub:

  ;----------------------------------
  ; Open the channel to upper screen
  ;----------------------------------
  call Open_Upper_Screen_Sub

  ;------------------------------
  ; Specify the beginning of UDG
  ;------------------------------
  ld hl, udgs                         ; user defined graphics (UDGs)
  ld (MEM_USER_DEFINED_GRAPHICS), hl  ; set up UDG system variable.

  ;--------------------------------------------
  ; Print text "Press a key for" at 3, 3
  ;--------------------------------------------
  ld A, 3                  ; row
  ld (text_row), A         ; store row coordinate
  ld B, A                  ; put row in B
  ld C, 3                  ; set column too
  ld HL, text_press_a_key  ; the address of the text to print in HL
  call Print_String_Sub

  ; Color the text box
  ld A,  BLUE_INK + WHITE_PAPER  ; color of the string
  ld BC, $0303
  ld DE, $1801                   ; length (D) is 24, height (E) is 1
  call Color_Text_Box_Sub

  ;--------------------------
  ;
  ;
  ; Loop to define five keys
  ;
  ;
  ;--------------------------
  ld B, 5  ; you will define five keys

Main_Ask_Again:
  push BC  ; store the counter

  ;----------------------------------------------------------
  ; Print a little yellow flashing arrow for the entry
  ; and set the "pointers" curr_port_addr and curr_mask_addr
  ;----------------------------------------------------------
  ld A, B
  cp 5
  jr z, Main_Up
  cp 4
  jr z, Main_Down
  cp 3
  jr z, Main_Left
  cp 2
  jr z, Main_Right
  cp 1
  jr z, Main_Fire
Main_Up:
  ld HL, arrow_up
  ld (udgs_arrows), HL
  ld HL, port_for_up
  ld (curr_port_addr), HL
  ld HL, mask_for_up
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Down:
  ld HL, arrow_down
  ld (udgs_arrows), HL
  ld HL, port_for_down
  ld (curr_port_addr), HL
  ld HL, mask_for_down
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Left:
  ld HL, arrow_left
  ld (udgs_arrows), HL
  ld HL, port_for_left
  ld (curr_port_addr), HL
  ld HL, mask_for_left
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Right:
  ld HL, arrow_right
  ld (udgs_arrows), HL
  ld HL, port_for_right
  ld (curr_port_addr), HL
  ld HL, mask_for_right
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Fire:
  ld HL, fire
  ld (udgs_arrows), HL
  ld HL, port_for_fire
  ld (curr_port_addr), HL
  ld HL, mask_for_fire
  ld (curr_mask_addr), HL

Main_Done:

  ld A, (text_row)          ; get current row
  inc A                     ; icrease it ...
  inc A                     ; ... by two ...
  ld (text_row), A          ; ... and store it back
  ld B, A                   ; store it in B too
  ld C,  5

  ; Color that little box
  ld A,  RED_INK + YELLOW_PAPER + FLASH  ; color of the string
  ld C,  5                               ; B should hold the row
  ld DE, $0101                           ; length (D) and height (E) are 1
  push BC
  call Color_Text_Box_Sub
  pop BC

  ld HL, (udgs_arrows)
  call Print_Udgs_Character_Sub  ; at this point, prints arrow

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
Main_Read_Next_Key:

  ;--------------------------------------
  ; Let IX point to all characters array
  ;--------------------------------------
  ld IX, all_characters - 1  ; make sure first inc points to all_characters

  ;-------------------------------------------------------------
  ; Set the HL to point to the beginning of array all_key_ports
  ;-------------------------------------------------------------
  ld HL, all_key_ports

  ;------------------------------
  ; There are eight rows of keys
  ;------------------------------
  ld D, 8              ; there are eight rows of keys

Main_Browse_Key_Rows:

  ; Keyboard row; load the port number into BC indirectly through HL
  ld C, (HL)       ; low byte into C
  inc HL
  ld B, (HL)       ; high byte into B
  inc HL

  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A         ; bit 0
  ld A, %00000001  ; store bit 0
  inc IX
  jr z, Main_Print_One
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A         ; bit 1
  ld A, %00000010  ; store bit 1
  inc IX
  jr z, Main_Print_One
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A         ; bit 2
  ld A, %00000100  ; store bit 2
  inc IX
  jr z, Main_Print_One
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A         ; bit 3
  ld A, %00001000  ; store bit 3
  inc IX
  jr z, Main_Print_One
  in A, (C)        ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A         ; bit 4
  ld A, %00010000  ; store bit 4
  inc IX
  jr z, Main_Print_One

  dec D

  jr nz, Main_Browse_Key_Rows

  jr Main_Read_Next_Key    ; if not pressed, repeat loop

  ;----------------------------
  ; Print the proper character
  ;----------------------------
Main_Print_One:

  ; Save port (BC already contains the port)
  ld HL, (curr_port_addr)
  ld (HL), C  ; low byte
  inc HL
  ld (HL), B  ; high byte

  ; Determine mask
  ld HL, (curr_mask_addr)
  ld (HL), A

  push IX                   ; copy IX ...
  pop HL                    ; ... to HL
  ld A, (text_row)          ; get current row
  ld B, A                   ; store it in B
  ld C, 5                   ; column is hard-coded
  call Print_Character_Sub

  ld A, (text_row)  ; retreive the last row
  ld B, A
  ld C, 5
  ld DE, $0101
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  call Color_Text_Box_Sub

  ;--------------------------------------
  ; Loop until all the keys are released
  ;--------------------------------------
  call Unpress_Sub

  ;--------------------------
  ; Retreive the key counter
  ;--------------------------
  pop BC

  dec B
  jp nz, Main_Ask_Again

  ;-----------------------------------------------------------------------
  ; End the key definition stage with a message that all keys are defined
  ;-----------------------------------------------------------------------
  ld BC, $1303              ; set row (D) to 15 and column (E) to 3
  ld HL, text_keys_defined  ; the address of the text to print in HL
  call Print_String_Sub

  ld BC, $1503              ; set row (D) to 15 and column (E) to 3
  ld HL, text_press_fire    ; the address of the text to print in HL
  call Print_String_Sub

  ;--------------------------------
  ;
  ;
  ; Press any key to continue loop
  ;
  ;
  ;--------------------------------
  call Press_Any_Key_Sub

  ;--------------------------------------
  ; Loop until all the keys are released
  ;--------------------------------------
  call Unpress_Sub

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

  ld BC, $0909
  ld HL, (udgs_arrows)
  call Print_Udgs_Character_Sub

  ;----------------
  ;
  ;
  ; Main game loop
  ;
  ;
  ;----------------
Main_Game_Loop:

  call Delay_Sub

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
  jr z, Hero_Not_Moved

  ;--------------------
  ; Now print for real
  ;--------------------
  ld BC, $0000         ; row and column
  ld H, 0              ; zero out H, so HL = 0x00XX
  ld A, (hero_row)     ; read the single byte into A
  ld L, A              ; put the value into L
  call Print_08_Bit_Number_Sub
  ld BC, $0100         ; row and column
  ld H, 0              ; zero out H, so HL = 0x00XX
  ld A, (hero_column)  ; read the single byte into A
  ld L, A              ; put the value into L
  call Print_08_Bit_Number_Sub
  ld A,  CYAN_PAPER
  ld BC, $0000
  ld DE, $0302
  call Color_Text_Box_Sub

Hero_Not_Moved:
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

Main_Browse_Keys_In_Game:

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

  jr z, Main_Game_Action_Key_Pressed

  dec D

  jr nz, Main_Browse_Keys_In_Game

  jr Main_Game_Loop

Main_Game_Action_Key_Pressed:

  ; Pick which action to take depending on which key was pressed
  ld A, D
  cp 5     ; upp is pressed
  jr z, Main_Game_Up_Pressed
  cp 4     ; down is pressed
  jr z, Main_Game_Down_Pressed
  cp 3     ; left is pressed
  jr z, Main_Game_Left_Pressed
  cp 2     ; right is pressed
  jr z, Main_Game_Right_Pressed
  cp 1
  jr z, Main_Game_Over

Main_Game_Up_Pressed:

  ; Set up the character for up
  ld HL, arrow_up
  ld BC, $0909
  call Print_Udgs_Character_Sub

  ; Decrease hero's row position on the map
  ld A, (hero_row)
  dec A
  ld (hero_row), A
  ld A, 1
  ld (hero_moved), A

  jp Main_Game_Loop  ; continue the main game loop, through key rows

Main_Game_Down_Pressed:

  ; Set up the character for down
  ld HL, arrow_down
  ld BC, $0909
  call Print_Udgs_Character_Sub

  ; Increase hero's row position on the map
  ld A, (hero_row)
  inc A
  ld (hero_row), A
  ld A, 1
  ld (hero_moved), A

  jp Main_Game_Loop  ; continue the main game loop, through key rows

Main_Game_Left_Pressed:

  ; Set up the character for left
  ld HL, arrow_left
  ld BC, $0909
  call Print_Udgs_Character_Sub

  ; Decrease hero's column position on the map
  ld A, (hero_column)
  dec A
  ld (hero_column), A
  ld A, 1
  ld (hero_moved), A

  jp Main_Game_Loop  ; continue the main game loop, through key rows

Main_Game_Right_Pressed:

  ; Set up the character for right
  ld HL, arrow_right
  ld BC, $0909
  call Print_Udgs_Character_Sub

  ; Increase hero's column position on the map
  ld A, (hero_column)
  inc A
  ld (hero_column), A
  ld A, 1
  ld (hero_moved), A

  jp Main_Game_Loop  ; continue the main game loop, through key rows

Main_Game_Over

  ei  ; <--= (re)enable interrupts if you want to return to OS/BASIC

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Press_Any_Key_Sub.asm"
  include "Subs/Unpress_Sub.asm"
  include "Subs/Print_Character_Sub.asm"
  include "Subs/Print_String_Sub.asm"
  include "Subs/Print_Udgs_Character_Sub.asm"
  include "Subs/Delay_Sub.asm"
  include "Subs/Print_08_Bit_Number_Sub.asm"

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
hero_row:    defb 100
hero_column: defb 200
hero_moved:  defb   0

;---------------------
; Texts to be written
;---------------------
text_press_a_key:   defb "Press keys for ", $94,32,$95,32,$96,32,$97,32,$98, 0
text_keys_defined:  defb "All keys defined", 0
text_press_fire:    defb "Press any key to continue", 0
text_up:            defb "up",               0
text_down:          defb "down",             0
text_left:          defb "left",             0
text_right:         defb "down",             0
text_fire:          defb "fire",             0

;---------------------------------------------------------------------------
; All key ports; used only in Unpressed now, maybe it can be defined there?
;---------------------------------------------------------------------------
all_key_ports:          ; this is like first array I created!
  defw KEYS_12345
  defw KEYS_67890
  defw KEYS_QWERT
  defw KEYS_YUIOP
  defw KEYS_ASDFG
  defw KEYS_HJKLENTER
  defw KEYS_CAPSZXCV
  defw KEYS_BNMSYMSPC

;-----------------------------------------------
; All characters you can get from Spectrum keys
; (Some had to be replaced by UDGs, of course)
;-----------------------------------------------
all_characters:
; Ordered by their bit positions in keyboard ports
  defb CHAR_1,     CHAR_2,     CHAR_3,     CHAR_4,     CHAR_5
  defb CHAR_0,     CHAR_9,     CHAR_8,     CHAR_7,     CHAR_6      ; reversed
  defb CHAR_Q_UPP, CHAR_W_UPP, CHAR_E_UPP, CHAR_R_UPP, CHAR_T_UPP
  defb CHAR_P_UPP, CHAR_O_UPP, CHAR_I_UPP, CHAR_U_UPP, CHAR_Y_UPP  ; reversed
  defb CHAR_A_UPP, CHAR_S_UPP, CHAR_D_UPP, CHAR_F_UPP, CHAR_G_UPP
  defb $90,        CHAR_L_UPP, CHAR_K_UPP, CHAR_J_UPP, CHAR_H_UPP  ; reversed
  defb $91,        CHAR_Z_UPP, CHAR_X_UPP, CHAR_C_UPP, CHAR_V_UPP
  defb $93,        $92,        CHAR_M_UPP, CHAR_N_UPP, CHAR_B_UPP  ; reversed

;-----------------------------------------------------------
; User defined graphics (start at $90, then go $91, $92 ...
;-----------------------------------------------------------
udgs:

enter:         defb $00, $02, $12, $32, $7E, $30, $10, $00  ; $90
caps_shift:    defb $00, $10, $38, $7C, $10, $10, $10, $00  ; $91
symbol_shift:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00  ; $92
space:         defb $00, $00, $00, $00, $00, $42, $7E, $00  ; $93
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
; Save a snapshot that starts execution at the address marked with Main_Sub
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main_Sub
  savebin "bojan.bin", Main_Sub, $ - Main_Sub
