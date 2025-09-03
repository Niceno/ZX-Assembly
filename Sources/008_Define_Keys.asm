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
  ld A,  3                  ; row
  ld (text_row), A          ; store row coordinate
  ld A,  3                  ; column
  ld (text_column), A       ; store column coordinate
  ld A, 24                  ; length of the string
  ld (text_length), A       ; store the length of the string
  ld A,  1                  ; height
  ld (text_height), A       ; store the height
  call Set_Text_Coords_Sub  ; set up our row/col coords.

  ; Store the address of the text to print in text_to_print_addr, using HL
  ld HL, text_press_a_key
  ld (text_to_print_addr), HL
  call Print_Null_Terminated_String_Sub


  ; Color the text box
  ld A, BLUE_INK + WHITE_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Color_Text_Box_Sub

  ;--------------------------
  ;
  ; Loop to define five keys
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
  ld (udgs_address), HL
  ld HL, port_for_up
  ld (curr_port_addr), HL
  ld HL, mask_for_up
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Down:
  ld HL, arrow_down
  ld (udgs_address), HL
  ld HL, port_for_down
  ld (curr_port_addr), HL
  ld HL, mask_for_down
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Left:
  ld HL, arrow_left
  ld (udgs_address), HL
  ld HL, port_for_left
  ld (curr_port_addr), HL
  ld HL, mask_for_left
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Right:
  ld HL, arrow_right
  ld (udgs_address), HL
  ld HL, port_for_right
  ld (curr_port_addr), HL
  ld HL, mask_for_right
  ld (curr_mask_addr), HL
  jr Main_Done
Main_Fire:
  ld HL, fire
  ld (udgs_address), HL
  ld HL, port_for_fire
  ld (curr_port_addr), HL
  ld HL, mask_for_fire
  ld (curr_mask_addr), HL

Main_Done:

  ld A, (text_row)                      ; current row
  inc A                                 ; icrease it ...
  inc A                                 ; .. by two
  ld (text_row), A                      ; store row coordinate
  ld A,  5                              ; column
  ld (text_column), A                   ; store column coordinate
  ld A,  1                              ; length of the string
  ld (text_length), A                   ; store the length
  ld A,  1                              ; height
  ld (text_height), A                   ; store the height
  ld A, RED_INK + YELLOW_PAPER + FLASH  ; color of the string
  ld (text_color), A                    ; store the color
  call Set_Text_Coords_Sub              ; set up our row/column coords

  ; Color that little box
  call Color_Text_Box_Sub

  call Print_Udgs_Character_Sub

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
  ld C, (HL)      ; low byte into C
  inc HL
  ld B, (HL)      ; high byte into B
  inc HL

  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 0, A        ; bit 0
  ld A, 0         ; store 0
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 1, A        ; bit 1
  ld A, 1         ; store 1
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 2, A        ; bit 2
  ld A, 2         ; store 2
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 3, A        ; bit 3
  ld A, 3         ; store 3
  inc IX
  jp z, Main_Print_One
  in A, (C)       ; read key states (1 = not pressed, 0 = pressed)
  bit 4, A        ; bit 4
  ld A, 4         ; store 4
  inc IX
  jp z, Main_Print_One

  dec D

  jr nz, Main_Browse_Key_Rows

  jp Main_Read_Next_Key    ; if not pressed, repeat loop

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

  ld A, (IX)
  rst ROM_PRINT_A_1     ; display it

  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld (text_color), A            ; store the color
  call Color_Text_Box_Sub       ; this seems to be needed
                                ; after calling ROM routines

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

  ;----------------------------------------------------------
  ; End the program with a message that all keys are defined
  ;----------------------------------------------------------
  ld A, 21                  ; row
  ld (text_row), A          ; store row coordinate
  ld A,  3                  ; column
  ld (text_column), A       ; store column coordinate
  ld A, 16                  ; length of the string
  ld (text_length), A       ; store length of the string
  ld A,  1                  ; height
  ld (text_height), A       ; store the height
  call Set_Text_Coords_Sub  ; set up our row/col coords.

  ; Store the address of the text to print in text_to_print_addr, using HL
  ld HL, text_keys_defined
  ld (text_to_print_addr), HL
  call Print_Null_Terminated_String_Sub

  ret  ; end of the main program

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen_Sub.asm"
  include "Subs/Set_Text_Coords_Sub.asm"
  include "Subs/Color_Text_Box_Sub.asm"
  include "Subs/Unpress.asm"
  include "Subs/Print_Null_Terminated_String_Sub.asm"
  include "Subs/Print_Udgs_Character_Sub.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;-----------------------------------
; Variables which define text boxes
;-----------------------------------
text_row:     defb  0  ; defb = define byte
text_column:  defb 15
text_length:  defb  1
text_height:  defb 10
text_color:   defb  0

;---------------------
; Texts to be written
;---------------------
text_press_a_key:   defb "Press keys for ", $94,32,$95,32,$96,32,$97,32,$98, 0
text_keys_defined:  defb "All keys defined", 0
text_up:            defb "up",               0
text_down:          defb "down",             0
text_left:          defb "left",             0
text_right:         defb "down",             0
text_fire:          defb "fire",             0

;----------------------------------------
; Holds the address of the text to print
;----------------------------------------
text_to_print_addr:  defw  0

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

screen_row_offset:  ; 24 words or 48 bytes
  defw     0  ; row  0
  defw    32  ; row  1
  defw    64  ; row  2
  defw    96  ; row  3
  defw   128  ; row  4
  defw   160  ; row  5
  defw   192  ; row  6
  defw   224  ; row  7
  defw  2048  ; row  8 = 32 * 8 * 8
  defw  2080  ; row  9
  defw  2112  ; row 10
  defw  2144  ; row 11
  defw  2176  ; row 12
  defw  2208  ; row 13
  defw  2240  ; row 14
  defw  2272  ; row 15
  defw  4096  ; row 16 = 32 * 8 * 8 * 2
  defw  4128  ; row 17
  defw  4160  ; row 18
  defw  4192  ; row 19
  defw  4224  ; row 20
  defw  4256  ; row 21
  defw  4288  ; row 22
  defw  4320  ; row 23

;-----------------------------------------------------------
; User defined graphics (start at $90, then go $91, $92 ...
;-----------------------------------------------------------
udgs:

enter:         defb $00, $02, $12, $32, $7E, $30, $10, $00  ; $90
caps_shift:    defb $00, $10, $38, $7C, $10, $10, $10, $00  ; $91
symbol_shift:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00  ; $92
space:         defb $00, $00, $00, $00, $00, $42, $7E, $00  ; $93
arrow_up:      defb $18, $24, $42, $C3, $24, $24, $24, $3C  ; $94
arrow_down:    defb $3C, $24, $24, $24, $C3, $42, $24, $18  ; $95
arrow_left:    defb $10, $30, $4F, $81, $81, $4F, $30, $10  ; $96
arrow_right:   defb $08, $0C, $F2, $81, $81, $F2, $0C, $08  ; $97
fire:          defb $99, $00, $3C, $A5, $A5, $3C, $00, $99  ; $98

udgs_address: defw arrow_up

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
