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

  ;---------------------
  ; Color that asterisk
  ;---------------------
  ld A, RED_INK + YELLOW_PAPER  ; color of the string
  ld B, 12                      ; row
  ld C, 16                      ; column
  ld E,  1                      ; length
  call Color_Line               ; A, BC and E are parameters

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
      ld C, (HL)  ; low byte into C
      inc HL
      ld B, (HL)  ; high byte into B
      inc HL

      in A, (C)   ; read key states (1 = not pressed, 0 = pressed)
      bit 0, A    ; bit 0
      inc IX
      inc IX
      jp z, .print_the_pressed_key
      in A, (C)   ; read key states (1 = not pressed, 0 = pressed)
      bit 1, A    ; bit 1
      inc IX
      inc IX
      jp z, .print_the_pressed_key
      in A, (C)   ; read key states (1 = not pressed, 0 = pressed)
      bit 2, A    ; bit 2
      inc IX
      inc IX
      jp z, .print_the_pressed_key
      in A, (C)   ; read key states (1 = not pressed, 0 = pressed)
      bit 3, A    ; bit 3
      inc IX
      inc IX
      jp z, .print_the_pressed_key
      in A, (C)   ; read key states (1 = not pressed, 0 = pressed)
      bit 4, A    ; bit 4
      inc IX
      inc IX
      jp z, .print_the_pressed_key

    dec D

    jr nz, .browse_key_rows

  jp .outer_infinite_loop    ; if not pressed, repeat loop

  ;----------------------------
  ; Print the proper character
  ;----------------------------
.print_the_pressed_key:

    ld H, (IX+1)  ; address of the character to print
    ld L, (IX+0)  ; address of the character to print
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
  include "Subs/Color_Line.asm"
  include "Subs/Print_Character.asm"
  include "Subs/Print_Udgs_Character.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

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

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "bojan.sna", Main
  savebin "bojan.bin", Main, $ - Main
