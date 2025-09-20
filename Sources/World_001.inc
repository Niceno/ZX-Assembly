;-------------------------
; Definition of the world
;-------------------------
world_address_table:
; type           row  col   definition
  db WORLD_TILE,   1,   1 : dw tile_ground     ; covers the whole world
                                               ; and it is a MUST!!!
  db WORLD_TILE, 128, 128 : dw tile_01_record
  db WORLD_TILE, 131, 131 : dw tile_02_record
  db WORLD_TILE, 128, 131 : dw tile_03_record
  db WORLD_TILE, 131, 128 : dw tile_04_record
  db WORLD_TILE, 134, 134 : dw tile_05_record
  db WORLD_TILE, 110, 106 : dw tile_05_record
  db WORLD_TILE,   2, 126 : dw tile_06_record  ; over the top
  db WORLD_TILE, 250, 126 : dw tile_06_record  ; rock bottom
  db WORLD_TILE, 126,   2 : dw tile_06_record  ; far left
  db WORLD_TILE, 126, 250 : dw tile_06_record  ; far right
  db WORLD_END                                 ; the end of the world

;----------------------------------------
; Tile records
;----------------------------------------
;                   dimensions   color
tile_ground   :  db  254,  254,  GREEN_PAPER
tile_01_record:  db    3,    3,  RED_PAPER    + BRIGHT
tile_02_record:  db    3,    3,  CYAN_PAPER   + BRIGHT
tile_03_record:  db    3,    3,  YELLOW_PAPER + BRIGHT
tile_04_record:  db    3,    3,  GREEN_PAPER  + BRIGHT
tile_05_record:  db   12,   16,  MAGENTA_PAPER
tile_06_record:  db    4,    4,  BLACK_PAPER
