;===============================================================================
; Create_3x3_World_Around_Hero:
;-------------------------------------------------------------------------------
; Purpose:
; - From the map of the entire world defined in the global varialbe
;   world_address_table, extract a 3x3 tileset and store it in the gloabal
;   variable world_around_hero_address_table
;
; Parameters:
; - none
;
; Global variables used:
; - hero_world_row
; - hero_world_col
; - world_address_table
; - world_around_hero_address_table
;
; Note:
; - Assumes that one tile is 16 x 16.  That allows easy division by 16
; - Some comments are a bit obsolete and assume that the world must be defined
;   by 16 x 16 tiles^2, that length of the single entry in world record is 5.
;-------------------------------------------------------------------------------
Create_3x3_World_Around_Hero:

  ;------------
  ;
  ; Rows first
  ;
  ;------------
  ld DE, WORLD_ENTRY_SIZE * WORLD_TILE_COLS  ; one whole row in world's record
  ld HL, world_address_table

  ld A, (hero_world_row)         ; place hero's world row into A
  srl A : srl A : srl A : srl A  ; divide it by 16

  ;--------------------------------------------------------
  ; Clamp rows, can't be smaller than 0 and bigger than 13
  ;--------------------------------------------------------
  cp 0
  jr z, .skip_zero_rows      ; tile row is already 0, don't decrease it

  dec A                      ; go up a row of tiles because ...
                             ; ... you want to start above hero
  cp 0
  jr z, .skip_zero_rows      ; if A is zero, skip the loop

  cp WORLD_TILE_ROWS - 2
  jr c, .rows_good           ; if A >= 14, c will not be set
                             ; if A < 14 c will be set
  ld A, WORLD_TILE_ROWS - 3  ; clamp to 13, you will browse 13,14,15

  ;------------------------------------
  ; Increase HL for the number of rows
  ;------------------------------------
.rows_good
  ld B, A    ; row number
.loop_rows
    add HL, DE
  djnz .loop_rows

.skip_zero_rows

  ;----------------
  ;
  ; Columns second
  ;
  ;----------------
  ld DE,  WORLD_ENTRY_SIZE       ; one column in world's record is 5

  ld A, (hero_world_col)         ; place hero's world column into A
  srl A : srl A : srl A : srl A  ; divide it by 16

  ;-----------------------------------------------------------
  ; Clamp columns, can't be smaller than 0 and bigger than 13
  ;-----------------------------------------------------------
  cp 0
  jr z, .skip_zero_columns       ; tile column is already 0, don't decrease it

  dec A                          ; go left

  cp 0
  jr z, .skip_zero_columns       ; A is zero, skip the loop

  cp WORLD_TILE_COLS - 2
  jr c, .cols_good           ; if A >= 14, c will not be set
                             ; if A < 14 c will be set
  ld A, WORLD_TILE_COLS - 3  ; clamp to 13, you will browse 13,14,15

  ;---------------------------------------
  ; Increase HL for the number of columns
  ;---------------------------------------
.cols_good
  ld B, A    ; column number
.loop_columns
    add HL, DE
  djnz .loop_columns

.skip_zero_columns

  ; HL now holds the source; the upper left tile in the 3x3 world
  push HL

  ;------------------------------------------------------------------
  ;
  ; Copy from world_address_table to world_around_hero_address_table
  ;
  ;------------------------------------------------------------------
  ld BC, WORLD_ENTRY_SIZE * 3             ; three columns are 15 bytes
  ld DE, world_around_hero_address_table  ; target
  ldir  ; copy (HL) -> (DE), this will copy the first row

  ; At this point, DE should correctly point
  ; to the second row of the world_around_hero

  pop HL                            ; retreive the old HL, the first row
  ld BC, WORLD_ENTRY_SIZE * WORLD_TILE_COLS  ; shift one row in world's record
  add HL, BC                                 ; go to the second row
  push HL                                    ; store the second row

  ld BC, WORLD_ENTRY_SIZE * 3  ; three columns are 15 bytes
  ldir                         ; copy (HL) -> (DE), copy the second row

  ; At this point, DE should correctly point
  ; to the third row of the world_around_hero

  pop HL                            ; retreive the previous HL, the second row
  ld BC, WORLD_ENTRY_SIZE * WORLD_TILE_COLS  ; shift one row in world's record
  add HL, BC                                 ; go to the third row

  ld BC, WORLD_ENTRY_SIZE * 3  ; three columns are 15 bytes
  ldir                         ; copy the third row

  ret

