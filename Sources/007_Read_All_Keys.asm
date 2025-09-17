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

  ;-----------------------------------
  ; Color the box for the pressed key
  ;-----------------------------------
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld B, 11                      ; row
  ld C, 15                      ; column
  ld D,  3                      ; length
  ld E,  3                      ; length
  call Color_Tile               ; A, BC and DE are parameters

  ;--------------------------------------
  ; Print DE register names and contents
  ; as well as the text for unique code
  ;--------------------------------------
  ld B,  0           ; row
  ld C,  0           ; column
  ld HL, reg_d
  call Print_String  ; HL & BC are the parameters
  ld B,  1           ; row
  ld C,  0           ; column
  ld HL, reg_e
  call Print_String  ; HL & BC are the parameter
  ld B,  2           ; row
  ld C,  0           ; column
  ld HL, unique_code
  call Print_String  ; HL & BC are the parameter

reg_d:        defb "D (key row):", 0
reg_e:        defb "E (key bit):", 0
unique_code:  defb "Unique code:", 0

  ;---------------------------------
  ; Color the box for the registers
  ;---------------------------------
  ld B,  0  ; row
  ld C,  0  ; column
  ld D,  3
  ld E, 15
  ld A, BLUE_INK + CYAN_PAPER
  call Color_Tile

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

  ;--------------------------------
  ;
  ; Infinite loop for reading keys
  ;
  ;--------------------------------
.outer_infinite_loop:

    ;-------------------------------------------------------------
    ; Set the HL to point to the beginning of array all_key_ports
    ;-------------------------------------------------------------
    ld HL, all_key_ports

    ;------------------------------
    ; There are eight rows of keys
    ;------------------------------
    ld D, 0              ; there are eight rows of keys

.browse_key_rows:

      ; Keyboard row; load the port number into BC indirectly through HL
      ld C, (HL)  ; low byte into C
      inc HL
      ld B, (HL)  ; high byte into B
      inc HL

      ; Read key states (1 = not pressed, 0 = pressed)
      in A, (C)
      and  %00011111  ; only bits 0..4 matter
      bit 0, A : ld E, 0 : jp z, .process_the_pressed_key
      bit 1, A : ld E, 1 : jp z, .process_the_pressed_key
      bit 2, A : ld E, 2 : jp z, .process_the_pressed_key
      bit 3, A : ld E, 3 : jp z, .process_the_pressed_key
      bit 4, A : ld E, 4 : jp z, .process_the_pressed_key

      ; Go up to D is 8
      inc D
      ld A, D
      cp 8

    jr nz, .browse_key_rows        ; go for the next key row

    jr z,  .outer_infinite_loop    ; if not pressed, repeat loop

  ;----------------------------
  ;
  ; Print the proper character
  ;
  ;----------------------------
.process_the_pressed_key:

    ; At this point, D holds the key port and E the bit which is pressed

    ;-----------------------------------------------------------
    ; Form the unique key code in A and copy it to HL and stack
    ;-----------------------------------------------------------

    ; Form the unique key in A
    ld A, E    ; load the accumulator with bits (%000...%100)
    sla A
    sla A
    sla A      ; if E was %100, A would now be %100000 (32)
    or D       ; if D was %111, A would now be %100111 (39)

    ; Place the unique key in HL (for printing) and on stack
    ld H, 0
    ld L, A
    push HL

    ; Print the unique key
    ld B,  2   ; row
    ld C, 12   ; column
    push DE
    call Print_08_Bit_Number
    pop DE

    ;-----------------------------
    ; Print the register contents
    ; (This is just for kicks)
    ;-----------------------------
    ld B,  0                  ; row
    ld C, 12                  ; column
    ld H,  0                  ; number to print
    ld L,  D                  ; number to print
    push DE
    call Print_08_Bit_Number
    pop DE  ; pushed as HL above
    ld B,  1                  ; row
    ld C, 12                  ; column
    ld H,  0                  ; number to print
    ld L,  E                  ; number to print
    push DE
    call Print_08_Bit_Number
    pop DE  ; pushed as HL above

    pop DE  ; pushed as HL above

    ;---------------------
    ; Print the character
    ;---------------------

    ; Set HL to point to the right character
    ld HL, all_characters_mem_coded
    add HL, DE
    add HL, DE

    ; Load DE with the address to whihc HL correctly points
    ld E, (HL)
    inc HL
    ld D, (HL)

    ; Swap DE and HL
    ex DE, HL

    ld B, 12      ; row
    ld C, 16      ; column
    call Print_Udgs_Character

  jp .outer_infinite_loop

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Calculate_Screen_Attribute_Address.asm"
  include "Subs/Color_Line.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Udgs/Print_Character.asm"
  include "Subs/Color_Tile.asm"
  include "Subs/Print_String.asm"
  include "Subs/Print_08_Bit_Number.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"
  include "Unique_Key_Codes_Sorted_By_Values.inc"

;------------------------------------------
; User defined characters for special keys
;------------------------------------------
mem_ente:  defb $00, $02, $12, $32, $7E, $30, $10, $00
mem_caps:  defb $00, $10, $38, $7C, $10, $10, $10, $00
mem_symb:  defb $00, $7E, $4E, $4E, $72, $72, $7E, $00
mem_spac:  defb $00, $00, $00, $00, $00, $42, $7E, $00

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan_007.sna", Main
  savebin "bojan_007.bin", Main, $ - Main
