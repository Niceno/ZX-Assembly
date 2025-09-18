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

  ;---------------
  ; Set the color
  ;---------------
  ld A, RED_INK + GREEN_PAPER     ; load A with desired color
  ld (MEM_STORE_SCREEN_COLOR), A  ; set the screen colors
  call ROM_CLEAR_SCREEN           ; clear the screen

  ;----------------------
  ; Set the border color
  ;----------------------
  ld A, GREEN_INK              ; load A with desired color
  call ROM_SET_BORDER_COLOR

  ;---------------------
  ; Create the viewport
  ;---------------------
  ld A, WHITE_PAPER + BLUE_INK
  ld B,  0  ; row
  ld C,  0  ; column
  ld D, 24  ; height of the viewport
  ld E, 32  ; length of the viewport
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
  ld HL, frame_q1
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
  ld HL, frame_q1
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

  call Browse_Key_Rows             ; outputs unique code in A, and flag in C
  bit 0, C                         ; was a key pressed?
  jr nz, .process_the_pressed_key  ; if a key was pressed process it

  jr .outer_loop_for_attributes          ; if not pressed, repeat loop

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

  call Browse_Key_Rows              ; outputs unique code in A, and flag in C
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
  include "Subs/Viewport/Scroll_Attributes_Up.asm"
  include "Subs/Viewport/Scroll_Attributes_Down.asm"
  include "Subs/Viewport/Scroll_Attributes_Left.asm"
  include "Subs/Viewport/Scroll_Attributes_Right.asm"
  include "Subs/Viewport/Scroll_Pixels_Up.asm"
  include "Subs/Viewport/Scroll_Pixels_Down.asm"
  include "Subs/Viewport/Scroll_Pixels_Left.asm"
  include "Subs/Viewport/Scroll_Pixels_Right.asm"
  include "Subs/Open_Upper_Screen.asm"
  include "Subs/Calculate_Screen_Pixel_Address.asm"
  include "Subs/Udgs/Print_Character.asm"
  include "Subs/Udgs/Print_Line_Tile.asm"
  include "Subs/Udgs/Print_Tile.asm"
  include "Subs/Udgs/Print_Line_Sprite.asm"
  include "Subs/Udgs/Print_Sprite.asm"
  include "Subs/Udgs/Merge_Character.asm"
  include "Subs/Udgs/Merge_Line_Sprite.asm"
  include "Subs/Udgs/Merge_Sprite.asm"
  include "Subs/Udgs/Merge_Line_Tile.asm"
  include "Subs/Udgs/Merge_Tile.asm"
  include "Subs/Merge_Grid.asm"
  include "Subs/Browse_Key_Rows.asm"
  include "Subs/Press_Any_Key.asm"
  include "Subs/Unpress.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

udgs:
  include "Subs/Grid_Cont_Dot.inc"

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
  savesna "bojan_012.sna", Main
  savebin "bojan_012.bin", Main, $ - Main
