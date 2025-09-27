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

    ; Update sprite
    ld A, (hero_orientation)

    cp HERO_GOES_N   : jr z, .pick_arrow_up
    cp HERO_GOES_NE  : jr z, .pick_arrow_up_right
    cp HERO_GOES_E   : jr z, .pick_arrow_right
    cp HERO_GOES_SE  : jr z, .pick_arrow_down_right
    cp HERO_GOES_S   : jr z, .pick_arrow_down
    cp HERO_GOES_SW  : jr z, .pick_arrow_down_left
    cp HERO_GOES_W   : jr z, .pick_arrow_left
    cp HERO_GOES_NW  : jr z, .pick_arrow_up_left

.pick_arrow_up         : ld HL, arrow_up         : jr .done_selecting_sprite
.pick_arrow_up_right   : ld HL, arrow_up_right   : jr .done_selecting_sprite
.pick_arrow_right      : ld HL, arrow_right      : jr .done_selecting_sprite
.pick_arrow_down_right : ld HL, arrow_down_right : jr .done_selecting_sprite
.pick_arrow_down       : ld HL, arrow_down       : jr .done_selecting_sprite
.pick_arrow_down_left  : ld HL, arrow_down_left  : jr .done_selecting_sprite
.pick_arrow_left       : ld HL, arrow_left       : jr .done_selecting_sprite
.pick_arrow_up_left    : ld HL, arrow_up_left    : jr .done_selecting_sprite

.done_selecting_sprite
    ld B, HERO_SCREEN_ROW : ld C, HERO_SCREEN_COL
    call Print_Udgs_Character

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

    ;--------------------------------------
    ;
    ; Action if the key for up was pressed
    ;
    ;--------------------------------------
.was_the_key_for_up_pressed:

    ld HL, key_for_up
    cp (HL)
    jp nz, .the_key_for_up_not_pressed

    ;------------------
    ; Hero goes north?
    ;------------------
    ld A, (hero_orientation)
    cp HERO_GOES_N
    jr nz, .hero_not_going_north

      ; Guard: already at upper edge?
      ld A, (hero_world_row)
      add A, WORLD_ROW_MIN_OFFSET      ; A = world_col_min
      or A                             ; faster than "cp 0"
      jp z, .got_stuck

      ; Update coordinates
      ld A, (hero_world_row)  : dec A : ld (hero_world_row),  A

      ; Hero goes north =--> screen scrolls down =--> set row max to row min
      ; Register A still holds hero_world_row here
      add A, WORLD_ROW_MIN_OFFSET           ; work out min
      ld (world_row_min), A                 ; store min
      ld (world_row_max), A                 ; set max = min
      call Viewport_Scroll_Attributes_Down  ; scroll
      call Draw_The_World                   ; this depends on world_limits

      jp .main_game_loop

.hero_not_going_north

    ;-----------------------
    ; Hero goes north-east?
    ;-----------------------
    ld A, (hero_orientation)
    cp HERO_GOES_NE
    jr nz, .hero_not_going_north_east

    jp .got_stuck

.hero_not_going_north_east

    ;----------------
    ; Hero goes east?
    ;----------------
    ld A, (hero_orientation)
    cp HERO_GOES_E
    jr nz, .hero_not_going_east

      ; Guard: already at right edge?
      ld A, (hero_world_col)
      add A, WORLD_COL_MAX_OFFSET      ; A = world_col_min
      cp WORLD_CELL_COLS - 1
      jp z, .got_stuck

      ; Update coordinates
      ld A, (hero_world_col)  : inc A : ld (hero_world_col),  A

      ; Hero goes east =--> screen scrolls left =--> set col min to col max
      ; Register A still holds hero_world_col here
      add A, WORLD_COL_MAX_OFFSET           ; work out max
      ld (world_col_max), A                 ; store max
      ld (world_col_min), A                 ; set min = max
      call Viewport_Scroll_Attributes_Left  ; scroll
      call Draw_The_World                   ; this depends on world_limits

      jp .main_game_loop

.hero_not_going_east

    ;-----------------------
    ; Hero goes south-east?
    ;-----------------------
    ld A, (hero_orientation)
    cp HERO_GOES_SE
    jr nz, .hero_not_going_down_right

    jp .got_stuck

.hero_not_going_down_right

    ;------------------
    ; Hero goes south?
    ;------------------
    ld A, (hero_orientation)
    cp HERO_GOES_S
    jr nz, .hero_not_going_south

      ; Guard: already at the bottom edge
      ld A, (hero_world_row)
      add A, WORLD_ROW_MAX_OFFSET      ; A = world_col_min
      cp WORLD_CELL_ROWS - 1
      jp z, .got_stuck

      ; Update coordinates
      ld A, (hero_world_row)  : inc A : ld (hero_world_row),  A

      ; Hero goes south =--> screen scrolls up =--> set row min to row max
      ; Register A still holds hero_world_row here
      add A, WORLD_ROW_MAX_OFFSET         ; work out max
      ld (world_row_max), A               ; store max
      ld (world_row_min), A               ; set min = max
      call Viewport_Scroll_Attributes_Up  ; scroll
      call Draw_The_World                 ; this depends on world_limits

      jp .main_game_loop

.hero_not_going_south

    ;-----------------------
    ; Hero goes south-west?
    ;-----------------------
    ld A, (hero_orientation)
    cp HERO_GOES_SW
    jr nz, .hero_not_going_south_west

    jp .got_stuck

.hero_not_going_south_west

    ;-----------------
    ; Hero goes west?
    ;-----------------
    ld A, (hero_orientation)
    cp HERO_GOES_W
    jr nz, .hero_not_going_west

      ; Guard: already at left edge?
      ld A, (hero_world_col)
      add A, WORLD_COL_MIN_OFFSET      ; A = world_col_min
      or A                             ; faster than "cp 0"
      jp z, .got_stuck

      ; Update coordinates
      ld A, (hero_world_col)  : dec A : ld (hero_world_col),  A

      ; Hero goes west =--> screen scrolls right =--> set col max to col min
      ; Register A still holds hero_world_col here
      add A, WORLD_COL_MIN_OFFSET            ; work out min
      ld (world_col_min), A                  ; store min
      ld (world_col_max), A                  ; set max = min
      call Viewport_Scroll_Attributes_Right  ; scroll
      call Draw_The_World                    ; this depends on world_limits

      jp .main_game_loop

.hero_not_going_west

    ;-----------------------
    ; Hero goes north-west?
    ;-----------------------
    ld A, (hero_orientation)
    cp HERO_GOES_NW
    jr nz, .hero_not_going_north_west

    jp .got_stuck

.hero_not_going_north_west

    ;--------------------------------------------------------------
    ;
    ; Action if the key for down was pressed (not implemented yet)
    ;
    ;--------------------------------------------------------------
.the_key_for_up_not_pressed

    ld HL, key_for_down
    cp (HL)
    jp nz, .the_key_for_down_not_pressed

    jp .got_stuck

    ;-----------------
    ; Action for left
    ;-----------------
.the_key_for_down_not_pressed:

    ld HL, key_for_left
    cp (HL)
    jr nz, .the_key_for_left_not_pressed

    ld A, (hero_orientation)
    dec A
    and %00000111 ; keep it in 0..7
    ld (hero_orientation), A

    call Unpress

    jp .main_game_loop

    ;------------------
    ; Action for right
    ;------------------
.the_key_for_left_not_pressed:

    ld HL, key_for_right
    cp (HL)
    jr nz, .the_key_for_right_not_pressed

    ld A, (hero_orientation)
    inc A
    and %00000111 ; keep it in 0..7
    ld (hero_orientation), A

    call Unpress

    jp .main_game_loop

.the_key_for_right_not_pressed:

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
.got_stuck:

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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Draw_The_World.asm"
  include "Create_3x3_World_Around_Hero.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   LOCAL DATA (first used here and in called functions)
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

; Hero's position and offset (not all of them will be used in the end)
hero_world_row:  defb  HERO_START_ROW
hero_world_col:  defb  HERO_START_COL

hero_orientation:  defb  HERO_GOES_N

; These four must be in this order - don't mess it up!
world_limits:
world_row_min:  defb  HERO_START_ROW + WORLD_ROW_MIN_OFFSET
world_col_min:  defb  HERO_START_COL + WORLD_COL_MIN_OFFSET
world_row_max:  defb  HERO_START_ROW + WORLD_ROW_MAX_OFFSET
world_col_max:  defb  HERO_START_COL + WORLD_COL_MAX_OFFSET

; The text written on the right-hand side od the screen, next to viewport
text_hero: defb "HERO", 0
text_view: defb "VIEW", 0

; Definition of hero's representation
arrow_up:          defb  $00, $18, $3C, $7E, $18, $18, $18, $00
arrow_up_right:    defb  $00, $1E, $0E, $1E, $3A, $70, $20, $00
arrow_down:        defb  $00, $18, $18, $18, $7E, $3C, $18, $00
arrow_down_right:  defb  $00, $20, $70, $3A, $1E, $0E, $1E, $00
arrow_left:        defb  $00, $10, $30, $7E, $7E, $30, $10, $00
arrow_down_left:   defb  $00, $04, $0E, $5C, $78, $70, $78, $00
arrow_right:       defb  $00, $08, $0C, $7E, $7E, $0C, $08, $00
arrow_up_left:     defb  $00, $78, $70, $78, $5C, $0E, $04, $00
fire:              defb  $08, $04, $0C, $2A, $3A, $7A, $66, $3C

