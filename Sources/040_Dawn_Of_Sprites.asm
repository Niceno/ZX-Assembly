;----------------------------------------------------------------------------
; Core constants for ZX Spectrum 48K: memory map, screen/attribute layout,
; colors, keyboard ports/keycodes, ROM char addresses, and project addresses
;----------------------------------------------------------------------------
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

  ;------------------------------------
  ; Set the color and clear the screen
  ;------------------------------------
  ld A, RED_INK + GREEN_PAPER     ; load A with desired color
  call Clear_Screen

  ;----------------------
  ; Set the border color
  ;----------------------
  ld A, GREEN_INK              ; load A with desired color
  call Set_Border_Color

  ;---------------------
  ; Create the viewport
  ;---------------------
  ld A, WHITE_PAPER + BLUE_INK  ; color for the viewport
  ld H, 1                       ; type of frame for the viewport
  ld L, YELLOW_PAPER + RED_INK
  call Viewport_Create

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B, 10  ; row
  ld C, 11  ; column
  ld D,  4  ; height of the sprite (in rows)
  ld E,  6  ; length of the sprite (in columns)
  ld HL, monster_01
  call Print_Udgs_Tile

  ld A,  RED_INK + YELLOW_PAPER
  ld B, 10  ; row
  ld C, 11  ; column
  ld D,  4  ; height in rows
  ld E,  6  ; length in columns
  call Color_Tile

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B,  2  ; row
  ld C, 19  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  ld HL, circle_q1
  call Print_Udgs_Sprite

  ld A,  BLACK_INK + WHITE_PAPER
  ld B,  2  ; row
  ld C, 19  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  call Color_Tile

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B,  9  ; row
  ld C,  2  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  ld HL, circle_q1
  call Print_Udgs_Sprite

  ld A,  RED_INK + WHITE_PAPER
  ld B,  9  ; row
  ld C,  2  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  call Color_Tile

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B, 20  ; row
  ld C,  7  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  ld HL, frame_v1_q1
  call Merge_Udgs_Sprite

  ld A,  MAGENTA_INK + CYAN_PAPER
  ld B, 20  ; row
  ld C,  7  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  call Color_Tile

  ;--------------------------------------------------------------
  ; Initialize coordinates and size of the box and print the box
  ;--------------------------------------------------------------
  ld B, 13  ; row
  ld C, 24  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  ld HL, frame_v1_q1
  call Merge_Udgs_Sprite

  ld A,  RED_INK + CYAN_PAPER
  ld B, 13  ; row
  ld C, 24  ; column
  ld D,  2  ; height of the sprite (in rows)
  ld E,  2  ; length of the sprite (in columns)
  call Color_Tile

  ;-----------------------------------------------------
  ; Merge the grid over whatever you have on the screen
  ;-----------------------------------------------------
  call Merge_Grid

  ;---------------------------
  ; Check attribute scrolling
  ;---------------------------
.outer_loop_for_attributes:

  call Browse_Key_Rows_For_One_Key  ; outputs unique code in A, and flag in C
  bit 0, C                          ; was a key pressed?
  jr nz, .process_the_pressed_key   ; if a key was pressed process it

  jr .outer_loop_for_attributes     ; if not pressed, repeat loop

.process_the_pressed_key:

  push AF  ; store the unique code
  call Press_Any_Key
  pop AF

  cp KEY_7
  jr nz, .key_for_up_attributes
  call Viewport_Scroll_Attributes_Up
.key_for_up_attributes

  cp KEY_6
  jr nz, .key_for_down_attributes
  call Viewport_Scroll_Attributes_Down
.key_for_down_attributes

  cp KEY_5
  jr nz, .key_for_left_attributes
  call Viewport_Scroll_Attributes_Left
.key_for_left_attributes

  cp KEY_8
  jr nz, .key_for_right_attributes
  call Viewport_Scroll_Attributes_Right
.key_for_right_attributes

  cp KEY_0
  jr nz, .key_for_exit_attributes
  jr .get_out_of_attributes
.key_for_exit_attributes

  push AF  ; store the unique code
  call Unpress
  pop AF

  jr .outer_loop_for_attributes

.get_out_of_attributes
  call Unpress

  ;-----------------------
  ; Check pixel scrolling
  ;-----------------------
.outer_loop_for_pixels:

  call Browse_Key_Rows_For_One_Key  ; outputs unique code in A, and flag in C
  bit 0, C                          ; was a key pressed?
  jr nz, .process_the_pixel_scroll  ; if a key was pressed process it

  jr .outer_loop_for_pixels         ; if not pressed, repeat loop

.process_the_pixel_scroll:

  push AF  ; store the unique code
  call Press_Any_Key
  pop AF

  cp KEY_7
  jr nz, .key_for_up_pixels
  call Viewport_Scroll_Pixels_Up
.key_for_up_pixels

  cp KEY_6
  jr nz, .key_for_down_pixels
  call Viewport_Scroll_Pixels_Down
.key_for_down_pixels

  cp KEY_5
  jr nz, .key_for_left_pixels
  call Viewport_Scroll_Pixels_Left
.key_for_left_pixels

  cp KEY_8
  jr nz, .key_for_right_pixels
  call Viewport_Scroll_Pixels_Right
.key_for_right_pixels

  cp KEY_0
  jr nz, .key_for_exit_pixels
  jr .get_out_of_pixels
.key_for_exit_pixels

  push AF  ; store the unique code
  call Unpress
  pop AF

  jr .outer_loop_for_pixels

.get_out_of_pixels

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Clear_Screen.asm"
  include "Shared/Set_Border_Color.asm"
  include "Shared/Viewport/Create.asm"
  include "Shared/Viewport/Scroll_Attributes_Up.asm"
  include "Shared/Viewport/Scroll_Attributes_Down.asm"
  include "Shared/Viewport/Scroll_Attributes_Left.asm"
  include "Shared/Viewport/Scroll_Attributes_Right.asm"
  include "Shared/Viewport/Scroll_Pixels_Up.asm"
  include "Shared/Viewport/Scroll_Pixels_Down.asm"
  include "Shared/Viewport/Scroll_Pixels_Left.asm"
  include "Shared/Viewport/Scroll_Pixels_Right.asm"
  include "Shared/Udgs/Print_Sprite.asm"
  include "Shared/Press_Any_Key.asm"
  include "Shared/Unpress.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   UTILITIES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Utilities/Merge_Grid.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Include/Global_Data.inc"

; The 8x8 sprites which follow, were created with the command:
; python.exe .\convert_sprite_8x8.py .\[name].8x8 in the directory Figures
ghost_01:        defb $3C, $7E, $DB, $99, $FF, $FF, $DB, $DB
human_01:        defb $18, $3C, $18, $FF, $18, $3C, $24, $66
monster_01:      defb $99, $BD, $5A, $7E, $42, $3C, $DB, $81
monster_02:      defb $24, $3C, $3C, $5A, $BD, $3C, $66, $42
monster_03:      defb $24, $7E, $FF, $DB, $7E, $42, $BD, $81
monster_04:      defb $42, $81, $BD, $5A, $66, $3C, $66, $A5
arrow_up:        defb $18, $24, $42, $C3, $24, $24, $24, $3C
arrow_down:      defb $3C, $24, $24, $24, $C3, $42, $24, $18
arrow_left:      defb $10, $30, $4F, $81, $81, $4F, $30, $10
arrow_right:     defb $08, $0C, $F2, $81, $81, $F2, $0C, $08
space_to_print:  defb $00, $00, $00, $00, $00, $00, $00, $00

circle_q1:  defb $03, $0F, $13, $33, $4F, $4F, $FF, $7F
circle_q2:  defb $C0, $F0, $F8, $FC, $FE, $FE, $FF, $FE 
circle_q3:  defb $BF, $CF, $70, $7F, $3F, $1F, $0F, $03 
circle_q4:  defb $FD, $F3, $0E, $FE, $FC, $F8, $F0, $C0 

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "040_Dawn_Of_Sprites.sna", Main
  savebin "040_Dawn_Of_Sprites.bin", Main, $ - Main
