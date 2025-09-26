;===============================================================================
; Play_The_Game
;-------------------------------------------------------------------------------
; Purpose:
; - Clears screen, runs main game loop
; - Returns to caller (menu) when done
;-------------------------------------------------------------------------------
Play_The_Game:

  call Unpress  ; unpress first

  ld A, (MEM_STORE_SCREEN_COLOR)  ; set color into A
  call Clear_Screen               ; clear the screen
  call Clear_Shadow               ; important

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

  ;----------------
  ; Draw the world
  ;----------------
  call Create_3x3_World_Around_Hero
  call Draw_The_World

  ;-----------------------------------------------------
  ; Merge the grid over whatever you have on the screen
  ;-----------------------------------------------------
  call Merge_Grid

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

    ;------------------------------
    ; Update the world around hero
    ;------------------------------
    call Create_3x3_World_Around_Hero

    ;------------------------
    ; Print hero coordinates
    ;------------------------
    ld B, 0 : ld C, 28
    ld HL, text_hero
    call Print_String

    ; Fetch hero's coordinates and print them
    ld A, (hero_world_row)    ; place hero's world row into A
    ld H, 0 : ld L, A         ; load HL pair with A (hero's row)
    ld B, 2 : ld C, 29        ; set row and column for printing
    call Print_08_Bit_Number  ; print it

    ld A, (hero_world_col)    ; place hero's world column into A
    ld H, 0 : ld L, A         ; load HL pair with A (hero's column)
    ld B, 3 : ld C, 29        ; set row and column for printing
    call Print_08_Bit_Number  ; print it

    ld B, 2 : ld C, 29
    ld D, 2 : ld E, 3
    ld A, CYAN_PAPER + BRIGHT
    call Color_Tile

    ; Fetch hero's coordinates, work out his tile coordinates and print them
    ld A, (hero_world_row)         ; place hero's world row into A
    srl A : srl A : srl A : srl A  ; divide it by 16
    ld H, 0 : ld L, A              ; load HL pair with A (hero's tile row)
    ld B, 5 : ld C, 29             ; set row and column for printing
    call Print_08_Bit_Number       ; print it

    ld A, (hero_world_col)         ; place hero's world column into A
    srl A : srl A : srl A : srl A  ; divide it by 16
    ld H, 0 : ld L, A              ; load HL pair with A (hero's tile column)
    ld B, 6 : ld C, 29             ; set row and column for printing
    call Print_08_Bit_Number       ; print it

    ld B, 5 : ld C, 29
    ld D, 2 : ld E, 3
    ld A, CYAN_PAPER + BRIGHT
    call Color_Tile

    ;------------------------
    ; Print view coordinates
    ;------------------------
    ld B, 8 : ld C, 28
    ld HL, text_view
    call Print_String

    ; Fetch world's min coordinates and print them
    ld A, (world_row_min)      ; place hero's row offset into A
    ld H, 0 : ld L, A          ; load HL pair with A
    ld B,10 : ld C, 29         ; set row and column for printing
    call Print_08_Bit_Number   ; print it

    ld A, (world_col_min)      ; place hero's column offset into A
    ld H, 0 : ld L, A          ; load HL pair with A
    ld B,11 : ld C, 29         ; set row and column for printing
    call Print_08_Bit_Number   ; print it

    ld B,10 : ld C, 29
    ld D, 2 : ld E, 3
    ld A, GREEN_PAPER + BRIGHT
    call Color_Tile

    ; Fetch world's min coordinates and print them
    ld A, (world_row_max)      ; place hero's row offset into A
    ld H, 0 : ld L, A          ; load HL pair with A
    ld B,13 : ld C, 29         ; set row and column for printing
    call Print_08_Bit_Number   ; print it

    ld A, (world_col_max)      ; place hero's column offset into A
    ld H, 0 : ld L, A          ; load HL pair with A
    ld B,14 : ld C, 29         ; set row and column for printing
    call Print_08_Bit_Number   ; print it

    ld B,13 : ld C, 29
    ld D, 2 : ld E, 3
    ld A, GREEN_PAPER + BRIGHT
    call Color_Tile

    ;-----------------------
    ; Create a little delay
    ;-----------------------
    ld B, 1
    call Delay

    ;-----------------------------
    ;
    ; Browse through all key rows
    ;
    ;-----------------------------
    call Browse_Key_Rows  ; A = unique code, C bit0 = 1 if any key pressed
    bit  0, C             ; check C register's zeroth bit

    jp z, .main_game_loop  ; no key pressed -> keep polling

    ;---------------------------------------------
    ;
    ; A key was pressed - process the action here
    ; (Note that here A holds the unique key code)
    ;
    ;---------------------------------------------

    ; Reset (restore) row and col coordinates
    ; (If they stayed like this, the whole viewport would redraw.)
    ex AF, AF'
    ld A, (hero_world_row) : add A, WORLD_ROW_MIN_OFFSET : ld (world_row_min), A
    ld A, (hero_world_col) : add A, WORLD_COL_MIN_OFFSET : ld (world_col_min), A
    ld A, (hero_world_row) : add A, WORLD_ROW_MAX_OFFSET : ld (world_row_max), A
    ld A, (hero_world_col) : add A, WORLD_COL_MAX_OFFSET : ld (world_col_max), A
    ex AF, AF'

    ;---------------
    ; Action for up
    ;---------------
.was_the_key_for_up_pressed:
    ld HL, key_for_up
    cp (HL)
    jr nz, .was_the_key_for_down_pressed

    ; Update sprite
    ld HL, arrow_up
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    ; Guard: already at upper edge?
    ld A, (hero_world_row)
    add A, WORLD_ROW_MIN_OFFSET      ; A = world_col_min
    or A                             ; faster than "cp 0"
    jp z, .got_stuck

    ; Update coordinates
    ld A, (hero_world_row)  : dec A : ld (hero_world_row),  A

    ; Hero goes up =--> screen scrolls down =--> set row max to row min
    ; Register A still holds hero_world_row here
    add A, WORLD_ROW_MIN_OFFSET           ; work out min
    ld (world_row_min), A                 ; store min
    ld (world_row_max), A                 ; set max = min
    call Viewport_Scroll_Attributes_Down  ; scroll
    call Draw_The_World                   ; this depends on world_limits

    jp .main_game_loop

    ;-----------------
    ; Action for down
    ;-----------------
.was_the_key_for_down_pressed:
    ld HL, key_for_down
    cp (HL)
    jr nz, .was_the_key_for_left_pressed

    ; Update sprite
    ld HL, arrow_down
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    ; Guard: already at the bottom edge
    ld A, (hero_world_row)
    add A, WORLD_ROW_MAX_OFFSET      ; A = world_col_min
    cp WORLD_CELL_ROWS - 1
    jp z, .got_stuck

    ; Update coordinates
    ld A, (hero_world_row)  : inc A : ld (hero_world_row),  A

    ; Hero goes down =--> screen scrolls up =--> set row min to row max
    ; Register A still holds hero_world_row here
    add A, WORLD_ROW_MAX_OFFSET         ; work out max
    ld (world_row_max), A               ; store max
    ld (world_row_min), A               ; set min = max
    call Viewport_Scroll_Attributes_Up  ; scroll
    call Draw_The_World                 ; this depends on world_limits

    jp .main_game_loop

    ;-----------------
    ; Action for left
    ;-----------------
.was_the_key_for_left_pressed:
    ld HL, key_for_left
    cp (HL)
    jr nz, .was_the_key_for_right_pressed

    ; Update sprite
    ld HL, arrow_left
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    ; Guard: already at left edge?
    ld A, (hero_world_col)
    add A, WORLD_COL_MIN_OFFSET      ; A = world_col_min
    or A                             ; faster than "cp 0"
    jp z, .got_stuck

    ; Update coordinates
    ld A, (hero_world_col)  : dec A : ld (hero_world_col),  A

    ; Hero goes left =--> screen scrolls right =--> set col max to col min
    ; Register A still holds hero_world_col here
    add A, WORLD_COL_MIN_OFFSET            ; work out min
    ld (world_col_min), A                  ; store min
    ld (world_col_max), A                  ; set max = min
    call Viewport_Scroll_Attributes_Right  ; scroll
    call Draw_The_World                    ; this depends on world_limits

    jp .main_game_loop

    ;------------------
    ; Action for right
    ;------------------
.was_the_key_for_right_pressed:
    ld HL, key_for_right
    cp (HL)
    jr nz, .was_the_key_for_fire_pressed

    ; Update sprite
    ld HL, arrow_right
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

    ; Guard: already at left edge?
    ld A, (hero_world_col)
    add A, WORLD_COL_MAX_OFFSET      ; A = world_col_min
    cp WORLD_CELL_COLS - 1
    jp z, .got_stuck

    ; Update coordinates
    ld A, (hero_world_col)  : inc A : ld (hero_world_col),  A

    ; Hero goes right =--> screen scrolls left =--> set col min to col max
    ; Register A still holds hero_world_col here
    add A, WORLD_COL_MAX_OFFSET           ; work out max
    ld (world_col_max), A                 ; store max
    ld (world_col_min), A                 ; set min = max
    call Viewport_Scroll_Attributes_Left  ; scroll
    call Draw_The_World                   ; this depends on world_limits

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

  ;----------------------------------
  ;
  ; You reched the edge of the world
  ;
  ;----------------------------------
.got_stuck

  ei
  push AF
  push BC
  ld B, 8
.flicker
    ld A, RED_INK  : call Set_Border_Color : halt
    ld A, CYAN_INK : call Set_Border_Color : halt
  djnz .flicker
  pop BC
  pop AF
  di

  call Unpress
  jp .main_game_loop

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Draw_The_World.asm"
  include "Create_3x3_World_Around_Hero.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SHARED SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Shared/Clear_Shadow.asm"
  include "Shared/Viewport/Create.asm"
  include "Shared/Viewport/Scroll_Attributes_Up.asm"
  include "Shared/Viewport/Scroll_Attributes_Down.asm"
  include "Shared/Viewport/Scroll_Attributes_Left.asm"
  include "Shared/Viewport/Scroll_Attributes_Right.asm"
  include "Shared/Delay.asm"
  include "Shared/Print_08_Bit_Number.asm"
  include "Shared/Copy_Shadow_Colors_To_Screen.asm"

