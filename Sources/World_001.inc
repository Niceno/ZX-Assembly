;-------------------------
; Definition of the world
;-------------------------
world_address_table:
  dw tile_00_record  ; this covers the whole world
  dw tile_01_record
  dw tile_02_record
  dw tile_03_record
  dw tile_04_record
  dw tile_05_record  ; starts inside, but breaks out at lower right
  dw tile_06_record  ; starts outside, but protrudes from upper left
  dw tile_07_record  ; everything smaller than min row
  dw tile_08_record  ; everything greater than max row
  dw tile_09_record  ; everything smaller than min col
  dw tile_10_record  ; everything greater than max col
  dw $0000           ; this marks the end of the world

;----------------------------------------
; Tile records
;----------------------------------------
;                    row0  col0  row1  col1  color
tile_00_record:  db    1,    1,  254,  254, GREEN_PAPER
tile_01_record:  db  128,  128,  130,  130, RED_PAPER    + BRIGHT
tile_02_record:  db  131,  131,  133,  133, CYAN_PAPER   + BRIGHT
tile_03_record:  db  128,  131,  130,  133, YELLOW_PAPER + BRIGHT
tile_04_record:  db  131,  128,  133,  130, GREEN_PAPER  + BRIGHT
tile_05_record:  db  134,  134,  150,  150, MAGENTA_PAPER
tile_06_record:  db  110,  110,  121,  121, MAGENTA_PAPER
tile_07_record:  db    0,  128,    1,  130, BLACK_PAPER  ; over the top
tile_08_record:  db  254,  128,  255,  130, BLACK_PAPER  ; rock bottom
tile_09_record:  db  128,    0,  130,    1, BLACK_PAPER  ; far left
tile_10_record:  db  128,  254,  130,  255, BLACK_PAPER  ; far right

